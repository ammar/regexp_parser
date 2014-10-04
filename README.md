# Regexp::Parser

## What?
A ruby library to help with lexing, parsing, and transforming regular expressions.

* Multilayered

  * A scanner based on [ragel](http://www.complang.org/ragel/)
  * A lexer that produces a "stream" of tokens
  * A parser that produces a "tree" of Regexp::Expression objects (OO API)

* Lexes and parses both 1.8 and 1.9 regular expression flavors
* Supports ruby 1.8, 1.9, 2.0, and 2.1 runtimes.

For an example of regexp_parser in use, see the [meta_re project](https://github.com/ammar/meta_re)

---
## Requirements

* ruby '1.8.7'..'2.1.3'
* ragel, but only if you want to hack on the scanner


_Note: It most probably still works with 1.8.6, but it hasn't been tested with that version in a while._

_Note: Should work with jruby. Last tested with version 1.7.10._

---
## Install

  `gem install regexp_parser`

---
## Usage

```ruby
require 'regexp_parser'
```

---
## Components

### Scanner
A ragel generated scanner that recognizes the cumulative syntax of both
supported flavors. Breaks the expression's text into tokens, including
their type, token, text, and start/end offsets within the original
pattern.

#### Example
The following scans the given pattern and prints out the type, token, text and
start/end offsets for each token found.

```ruby
require 'regexp_parser'

Regexp::Scanner.scan /(ab?(cd)*[e-h]+)/  do |type, token, text, ts, te|
  puts "type: #{type}, token: #{token}, text: '#{text}' [#{ts}..#{te}]"
end

# output
# type: group, token: capture, text: '(' [0..1]
# type: literal, token: literal, text: 'ab' [1..3]
# type: quantifier, token: zero_or_one, text: '?' [3..4]
# type: group, token: capture, text: '(' [4..5]
# type: literal, token: literal, text: 'cd' [5..7]
# type: group, token: close, text: ')' [7..8]
# type: quantifier, token: zero_or_more, text: '*' [8..9]
# type: set, token: open, text: '[' [9..10]
# type: set, token: range, text: 'e-h' [10..13]
# type: set, token: close, text: ']' [13..14]
# type: quantifier, token: one_or_more, text: '+' [14..15]
# type: group, token: close, text: ')' [15..16]
```

A one-liner that returns an array of the textual parts of the given pattern:

```ruby
Regexp::Scanner.scan( /(cat?([bhm]at)){3,5}/ ).map {|token| token[2]}
#=> ["(", "cat", "?", "(", "[", "b", "h", "m", "]", "at", ")", ")", "{3,5}"]
```


#### Notes
  * The scanner performs basic syntax error checking, like detecting missing
    balancing punctuation and premature end of pattern. Flavor validity checks
    are performed in the lexer.

  * To keep the scanner simple(r) and fairly reusable for other uses, it
    does not perform lexical analysis on the tokens, sticking to the task
    of tokenizing and leaving lexical analysis upto to the lexer.

  * If the input is a ruby Regexp object, the scanner calls #source on it to
    get its string representation. #source does not include the options of
    expression (m, i, and x) To include the options the scan, #to_s should
    be called on the Regexp before passing it to the scanner, or any of the
    higher layers.


---
### Syntax
Defines the supported tokens for a specific engine implementation (aka a
flavor). Syntax classes act as lookup tables, and are layered to create
flavor variations. Syntax only comes into play in the lexer.

#### Example
The following instantiates the syntax for Ruby 1.9 and checks a couple of its
implementations features, and then does the same for Ruby 1.8:

```ruby
require 'regexp_parser'

ruby_19 = Regexp::Syntax.new 'ruby/1.9'
ruby_19.implements? :quantifier, :zero_or_one             # => true
ruby_19.implements? :quantifier, :zero_or_one_reluctant   # => true
ruby_19.implements? :quantifier, :zero_or_one_possessive  # => true

ruby_18 = Regexp::Syntax.new 'ruby/1.8'
ruby_18.implements? :quantifier, :zero_or_one             # => true
ruby_18.implements? :quantifier, :zero_or_one_reluctant   # => true
ruby_18.implements? :quantifier, :zero_or_one_possessive  # => false
```


#### Notes
  * Variatiions on a token, for example a named group with < and > vs one with a
    pair of single quotes, are specified with an underscore followed by two
    characters appended to the base token. In the previous named group example,
    the tokens would be :named_ab (angle brackets) and :named_sq (single quotes).
    These variations are normalized by the syntax to :named.

#### TODO
  * Add flavor limits: like Ruby 1.8's maximum allowed number of grouped 
    expressions (253).


---
### Lexer
Sits on top of the scanner and performs lexical analysis on the tokens that
it emits. Among its tasks are breaking quantified literal runs, collecting the
emitted token structures into an array of Token objects, calculating their
nesting depth, normalizing tokens for the parser, and checkng if the tokens
are implemented by the given syntax flavor.

Tokens objects are Structs, basically data objects, with a few helper methods,
like #next, #previous, #offsets and #length.

#### Example
The following example scans the given pattern, checks it against the ruby 1.8
syntax, and prints the token objects' text.

```ruby
require 'regexp_parser'

Regexp::Lexer.scan /a?(b(c))*[d]+/ do |token|
  puts "#{'  ' * token.level}#{token.text}"
end

# output
# a
# ?
# (
#   b
#   (
#     c
#   )
# )
# *
# [
# d
# ]
# +
```

A one-liner that returns an array of the textual parts of the given pattern.
Compare the output with that of the one-liner example of the Scanner; notably
how the sequence 'cat' is treated.

```ruby
Regexp::Lexer.scan( /(cat?([b]at)){3,5}/ ).map {|token| token.text}
#=> ["(", "ca", "t", "?", "(", "[", "b", "]", "at", ")", ")", "{3,5}"]
```

#### Notes
  * The default syntax is that of the latest released version of ruby.

  * The lexer performs some basic parsing to determine the depth of a the
    emitted tokens. This responsibility might be relegated to the scanner.


---
### Parser
Sits on top of the lexer and transforms the "stream" of Token objects emitted
by it into a tree of Expression objects represented by an instance of the
Expression::Root class. See Expression below for more information.

#### Example

```ruby
require 'regexp_parser'

regex = /a?(b)*[c]+/m

# using #to_s on the Regexp object to include options. Note that this turns the
# expression into '(?m-ix:a?(b)*[c]+)', thus the Group::Options in the output
root = Regexp::Parser.parse( regex.to_s, 'ruby/2.1')

root.multiline?         # => true (aliased as m?)
root.case_insensitive?  # => false (aliased as i?)

# simple tree walking method
def walk(e, depth = 0)
  puts "#{'  ' * depth}> #{e.class}"

  if e.respond_to?(:expressions)
    e.each {|s| walk(s, depth+1) }
  end
end

walk(root)

# output
> Regexp::Expression::Root
  > Regexp::Expression::Group::Options
    > Regexp::Expression::Literal
    > Regexp::Expression::Group::Capture
      > Regexp::Expression::Literal
    > Regexp::Expression::CharacterSet
```

Note: quantifiers do not appear in the output because they are members of the
Expression class. See the next section for more details.

---
### Expression
The base class of all objects returned by the parser, implements most of the
functions that are common to all expression classes.

Each Expression object contains the following members:

  * quantifier: an instance of Expression::Quantifier that holds the details
    of repetition for the Expression. Has a nil value if the expression is not
    quantified.

  * expressions: an array, holds the sub-expressions for the expression if it
    is a group or alternation expression. Empty if the expression doesn't have
    sub-expressions.

  * options: a hash, holds the keys :i, :m, and :x with a boolean value that
    indicates if the expression has a given option.

Expressions also contain the following "lower level" members
(from the scanner/lexer)

  * type: a symbol, denoting the expression type, such as :group, :quantifier
  * token: a symbol, for the object's token, or opening token (in the case of
    groups and sets)
  * text: a string, the text of the expression (same as token for nesting expressions)

Every expressions also has the following methods:

  * to_s: returns the string representation of the expression.
  * <<: adds sub-expresions to the expression.
  * each: iterates over the expressions sub-expressions, if any.
  * []: access sub-expressions by index.
  * quantified?: return true if the expression was followed by a quantifier.
  * quantity: returns an array of the expression's min and max repetitions.
  * greedy?: returns true if the expression's quantifier is greedy.
  * reluctant? or lazy?: returns true if the expression's quantifier is
    reluctant.
  * possessive?: returns true if the expression's quantifier is possessive.
  * multiline? or m?: returns true if the expression has the m option
  * case_insensitive? or ignore_case? or i?: returns true if the expression
    has the i option
  * free_spacing? or extended? or x?: returns true if the expression has the x
    option

A special expression class Expression::Sequence is used to hold the array of
possible alternatives within an Expression::Alternation expression.


## Scanner Syntax
The following syntax elements are supported by the scanner. 

  - Alternation: a|b|c, etc.
  - Anchors: ^, $, \b, etc.
  - Character Classes _(aka Sets)_: [abc], [^\]]
  - Character Types: \d, \H, \s, etc.
  - Escape Sequences: \t, \+, \?, etc.
  - Grouped Expressions
    - Assertions
      - Lookahead: (?=abc)
      - Negative Lookahead: (?!abc)
      - Lookabehind: (?<=abc)
      - Negative Lookbehind: (?<\!abc)
    - Atomic: (?>abc)
    - Back-references:
      - Named: \k<name>
      - Nest Level: \k<n-1>
      - Numbered: \k<1>
      - Relative: \k<-2>
    - Capturing: (abc)
    - Comment: (?# comment)
    - Named: (?<name>abc)
    - Options: (?mi-x:abc)
    - Passive: (?:abc)
    - Sub-expression Calls: \g<name>, \g<1>
  - Literals: abc, def?, etc.
  - POSIX classes: [:alpha:], [:print:], etc.
  - Quantifiers
    - Greedy: ?, *, +, {m,M}
    - Reluctant: ??, *?, +?, {m,M}?
    - Possessive: ?+, *+, ++, {m,M}+
  - String Escapes
    - Control: \C-C, \cD, etc.
    - Hex: \x20, \x{701230}, etc.
    - Meta: \M-c, \M-\C-C etc.
    - Octal: \0, \01, \012
    - Unicode: \uHHHH, \u{H+ H+}
  - Traditional Back-references: \1 thru \9
  - Unicode Properties:
    - Age: \p{Age=2.1}, \P{age=5.2}, etc.
    - Classes: \p{Alpha}, \P{Space}, etc.
    - Derived Properties: \p{Math}, \P{Lowercase}, etc.
    - General Categories: \p{Lu}, \P{Cs}, etc.
    - Scripts: \p{Arabic}, \P{Hiragana}, etc.
    - Simple Properties: \p{Dash}, \p{Extender}, etc.

See something missing? Please submit an [issue](https://github.com/ammar/regexp_parser/issues)

## References
Documentation and information being read while working on this project.

#### Ruby Flavors
* Oniguruma Regular Expressions [link](http://www.geocities.jp/kosako3/oniguruma/doc/RE.txt)
* Read Ruby > Regexps [link](https://github.com/runpaint/read-ruby/blob/master/src/regexps.xml)


#### Regular Expressions
* Mastering Regular Expressions, By Jeffrey E.F. Friedl (2nd Edition) [book](http://oreilly.com/catalog/9781565922570/)
* Regular Expression Flavor Comparison [link](http://www.regular-expressions.info/refflavors.html)
* Enumerating the strings of regular languages [link](http://www.cs.dartmouth.edu/~doug/nfa.ps.gz)


#### Unicode
* Unicode Explained, By Jukka K. Korpela. [book](http://oreilly.com/catalog/9780596101213)
* Unicode Derived Properties [link](http://www.unicode.org/Public/UNIDATA/DerivedCoreProperties.txt)
* Unicode Property Aliases [link](http://www.unicode.org/Public/UNIDATA/PropertyAliases.txt)
* Unicode Regular Expressions [link](http://www.unicode.org/reports/tr18/)
* Unicode Standard Annex #44 [link](http://www.unicode.org/reports/tr44/)

## Thanks
This work is based on and inspired by the hard work and ideas of many people,
directly or indirectly. The following are only a few of those that should be 
thanked.

* Adrian Thurston, for developing [ragel](http://www.complang.org/ragel/).
* Caleb Clausen, for feedback, which inspired this, valuable insights on structuring the parser,
  and lots of [cool code](http://github.com/coatl).
* Jan Goyvaerts, for his [excellent resource](http://www.regular-expressions.info) on regular expressions.
* Run Paint Run Run, for his work on [Read Ruby](https://github.com/runpaint/read-ruby)
* Yukihiro Matsumoto, of course! For "The Ruby", of course!

---
##### Copyright
_Copyright (c) 2010-2014 Ammar Ali. See LICENSE file for details._
