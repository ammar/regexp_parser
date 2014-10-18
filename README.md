# Regexp::Parser [![Gem Version](https://badge.fury.io/rb/regexp_parser.svg)](http://badge.fury.io/rb/regexp_parser) [![Build Status](https://secure.travis-ci.org/ammar/regexp_parser.png?branch=master)](http://travis-ci.org/ammar/regexp_parser) [![Code Climate](https://codeclimate.com/github/ammar/regexp_parser.png)](https://codeclimate.com/github/ammar/regexp_parser/badges)

A ruby library to help with lexing, parsing, and transforming regular expressions.

* Multilayered
  * A scanner/tokenizer based on [ragel](http://www.complang.org/ragel/)
  * A lexer that produces a "stream" of token objects.
  * A parser that produces a "tree" of **Regexp::Expression** objects (OO API)
* Recognizes ruby 1.8, 1.9, and 2.x regular expressions [See Scanner Syntax](#scanner-syntax)
* Unicode literals (UTF-8) and properties (as of [Unicode 7.0.0](http://www.unicode.org/versions/Unicode7.0.0/))
* Runs on ruby 1.8, 1.9, 2.x, and jruby (1.9 mode) runtimes.

_For an example of regexp_parser in use, see the [meta_re project](https://github.com/ammar/meta_re)_


---
## Requirements

* Ruby version >= 1.8.7 (1.9.x, 2.x.x)
* Ragel, but only if you want to build the gem or work on the scanner.


_Note: See the .travis.yml file for covered versions._


---
## Install

Install the gem with:

  `gem install regexp_parser`

Or, add it to your project's `Gemfile`:

```gem 'regexp_parser', '~> X.Y.Z'```

See rubygems for the the [latest version number](https://rubygems.org/gems/regexp_parser)


---
## Usage

The three main modules are **Scanner**, **Lexer**, and **Parser**. Each of them
provides a single method that takes a regular expression (as a RegExp object or
a string) and returns its results. The **Lexer** and the **Parser** accept an
optional second argument that specifies the syntax version, like 'ruby/2.0',
which defaults to the host ruby version (using RUBY_VERSION).

Here are the basic usage examples:

```ruby
require 'regexp_parser'

Regexp::Scanner.scan(regexp)

Regexp::Lexer.lex(regexp)

Regexp::Parser.parse(regexp)
```

All three methods accept a block as the last argument, which, if given, gets
called with the results as follows:

* **Scanner**: the block gets passed the results as they are scanned. See the
  example in the next section for details.

* **Lexer**: after completion, the block gets passed the tokens one by one.
  _The result of the block is returned._

* **Parser**: after completion, the block gets passed the root expression.
  _The result of the block is returned._


---
## Components

### Scanner
A ragel generated scanner that recognizes the cumulative syntax of all
supported syntax versions. It breaks a given expression's text into the
smallest parts, and identifies their type, token, text, and start/end
offsets within the pattern.


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

A one-liner that uses map on the result of the scan to return the textual
parts of the pattern:

```ruby
Regexp::Scanner.scan( /(cat?([bhm]at)){3,5}/ ).map {|token| token[2]}
#=> ["(", "cat", "?", "(", "[", "b", "h", "m", "]", "at", ")", ")", "{3,5}"]
```


#### Notes
  * The scanner performs basic syntax error checking, like detecting missing
    balancing punctuation and premature end of pattern. Flavor validity checks
    are performed in the lexer, which uses a syntax object.

  * If the input is a ruby **Regexp** object, the scanner calls #source on it to
    get its string representation. #source does not include the options of
    the expression (m, i, and x) To include the options in the scan, #to_s
    should be called on the **Regexp** before passing it to the scanner or any
    of the other modules.

  * To keep the scanner simple(r) and fairly reusable for other purposes, it
    does not perform lexical analysis on the tokens, sticking to the task
    of identifying the smallest possible tokens and leaving lexical analysis
    to the lexer.


---
### Syntax
Defines the supported tokens for a specific engine implementation (aka a
flavor). Syntax classes act as lookup tables, and are layered to create
flavor variations. Syntax only comes into play in the lexer.

#### Example
The following instantiates syntax objects for Ruby 2.0, 1.9, 1.8, and
checks a few of their implementation features.

```ruby
require 'regexp_parser'

ruby_20 = Regexp::Syntax.new 'ruby/2.0'
ruby_20.implements? :quantifier,  :zero_or_one             # => true
ruby_20.implements? :quantifier,  :zero_or_one_reluctant   # => true
ruby_20.implements? :quantifier,  :zero_or_one_possessive  # => true
ruby_20.implements? :conditional, :condition               # => true

ruby_19 = Regexp::Syntax.new 'ruby/1.9'
ruby_19.implements? :quantifier,  :zero_or_one             # => true
ruby_19.implements? :quantifier,  :zero_or_one_reluctant   # => true
ruby_19.implements? :quantifier,  :zero_or_one_possessive  # => true
ruby_19.implements? :conditional, :condition               # => false

ruby_18 = Regexp::Syntax.new 'ruby/1.8'
ruby_18.implements? :quantifier,  :zero_or_one             # => true
ruby_18.implements? :quantifier,  :zero_or_one_reluctant   # => true
ruby_18.implements? :quantifier,  :zero_or_one_possessive  # => false
ruby_18.implements? :conditional, :condition               # => false
```


#### Notes
  * Variatiions on a token, for example a named group with angle brackets (< and >)
    vs one with a pair of single quotes, are specified with an underscore followed
    by two characters appended to the base token. In the previous named group example,
    the tokens would be :named_ab (angle brackets) and :named_sq (single quotes).
    These variations are normalized by the syntax to :named.


---
### Lexer
Sits on top of the scanner and performs lexical analysis on the tokens that
it emits. Among its tasks are; breaking quantified literal runs, collecting the
emitted token attributes into Token objects, calculating their nesting depth,
normalizing tokens for the parser, and checkng if the tokens are implemented by
the given syntax version.

The Tokens returned by the lexer are Struct objects, with a few helper methods; #next,
 #previous, #offset, #length, and #to_h. Each token also has the following members:

- **type**:  a symbol, specifies the category of the token, such as :anchor, :set, :meta.
- **token**: a symbol, the specific token for the type, such as :eol, :range, :alternation.
- **text**: a string, the text of token, such as '$', 'a-z', '|'.
- **ts**: an integer, the start offset within the entire expression.
- **te**: an integer, the end offset within the entire expression.
- **level**: an integer, the group nesting level at which the token appears.
- **set_level**: an integer, the character set nesting level at which the token appears.
- **conditional_level**: an integer, the conditional expression nesting level at which the token appears.

#### Example
The following example lexes the given pattern, checks it against the ruby 1.9
syntax, and prints the token objects' text indented to their level.

```ruby
require 'regexp_parser'

Regexp::Lexer.scan /a?(b(c))*[d]+/, 'ruby/1.9' do |token|
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
Compare the output with that of the one-liner example of the **Scanner**; notably
how the sequence 'cat' is treated. The 't' is seperated because it's followed
by a quantifier that only applies to it.

```ruby
Regexp::Lexer.scan( /(cat?([b]at)){3,5}/ ).map {|token| token.text}
#=> ["(", "ca", "t", "?", "(", "[", "b", "]", "at", ")", ")", "{3,5}"]
```

#### Notes
  * The syntax argument is optional. It defaults to the version of the ruby
    interpreter in use, as returned by RUBY_VERSION.

  * The lexer normalizes some tokens, as noted in the Syntax section above.


---
### Parser
Sits on top of the lexer and transforms the "stream" of Token objects emitted
by it into a tree of Expression objects represented by an instance of the
Expression::Root class.


#### Example

```ruby
require 'regexp_parser'

regex = /a?(b)*[c]+/m

# using #to_s on the Regexp object to include its options. Note that this
# turns the expression into '(?m-ix:a?(b)*[c]+)', thus the appearance of
# the Group::Options node in the output
root = Regexp::Parser.parse( regex.to_s, 'ruby/2.1')

# Check the regexp options
root.multiline?         # => true (aliased as m?)
root.case_insensitive?  # => false (aliased as i?)

# simple tree walking method (depth-first, pre-order)
def walk(e, depth = 0)
  puts "#{'  ' * depth}> #{e.class}"

  if e.respond_to?(:expressions)
    e.each {|s| walk(s, depth+1) }
  end
end

walk(root)

# output
# > Regexp::Expression::Root
#   > Regexp::Expression::Group::Options
#     > Regexp::Expression::Literal
#     > Regexp::Expression::Group::Capture
#       > Regexp::Expression::Literal
#     > Regexp::Expression::CharacterSet
```

_Note: quantifiers do not appear in the output because they are members of the
Expression class. See the next section for details._


---
### Expression & Subexpression
The **Expression** class is the base class of all objects returned by the
parser. It implements the functions that are common to all expressions.

The **Subexpression** class is the base class for expressions that can contain
subexpressions.


Each Expression object contains the following attributes:

  * **quantifier**: an instance of Expression::Quantifier that holds the details
    of repetition for the Expression. Has a nil value if the expression is not
    quantified.
  * **options**: a hash, holds the keys :i, :m, and :x with a boolean value that
    indicates if the expression has a given option.

Expressions also contain the following members from the scanner/lexer:

  * **type**: a symbol, denoting the expression type, such as :group, :quantifier
  * **token**: a symbol, for the object's token, or opening token (in the case of
    groups and sets)
  * **text**: a string, the text of the expression (same as token for nesting expressions)
  * **ts**: an integer, the start offset within the while expression.


Every expression also has the following methods:

  * **to_s**: returns the string representation of the expression.
  * **quantified?**: return true if the expression was followed by a quantifier.
  * **quantity**: returns an array of the expression's min and max repetitions.
  * **greedy?**: returns true if the expression's quantifier is greedy.
  * **reluctant?** or **lazy?**: returns true if the expression's quantifier is
    reluctant.
  * **terminal?**: returns false if the expression has subexpressions (i.e. is a Subexpression)
  * **possessive?**: returns true if the expression's quantifier is possessive.
  * **multiline?** or **m?**: returns true if the expression has the m option
  * **case_insensitive?** or **ignore_case?** or **i?**: returns true if the expression
    has the i option
  * **free_spacing?** or **extended?** or **x?**: returns true if the expression has the x
    option

On Ruby 2.0 and later:
  * **default_classes?** or **d?**: returns true if the expression has the d option
  * **ascii_classes?** or **a?**: returns true if the expression has the a option
  * **unicode_classes?** or **u?**: returns true if the expression has the u option

In addition to the attributes and methods of **Expression**, **Subexpression**
objects also contain the following:

  * **expressions**: an array, holds the sub-expressions for the expression if it
    is a group or alternation expression. Empty if the expression doesn't have
    sub-expressions.

And they have have the following extra methods:

  * **<<**: adds sub-expresions to the expression.
  * **[]**: access sub-expressions by index.
  * **each**: iterates over the sub-expressions, if any.
  * **first**, **last**: return the first/last expressions of the subexpression.
  * **length**: returns the number of subexpressions in the expression.
  * **empty?**: return true if the subexpression does not have any subexpressions.


A special expression class **Expression::Sequence** is used to hold the
expressions of a branch within an **Expression::Alternation** expression. For
example, the expression 'b[ai]t|h[ai]t|p[ai]t' would result in an alternation with 3
sequences, one for each possible alternative, each of which contains 3
expression objects.


## Scanner Syntax
The following syntax features are recognized by the scanner:


| Syntax Feature                        | Examples                                                |          |
| ------------------------------------- | ------------------------------------------------------- |:--------:|
| **Alternation**                       | `a|b|c`                                                 | &#x2713; |
| **Anchors**                           | `^`, `$`, `\b`                                          | &#x2713; |
| **Character Classes**                 | `[abc]`, `[^\\]`, `[a-d&&g-h]`, `[a=e=b]`               | &#x2713; |
| **Character Types**                   | `\d`, `\H`, `\s`                                        | &#x2713; |
| **Conditional Exps.**                 | `(?(cond)yes-subexp)`, `(?(cond)yes-subexp|no-subexp)`  | &#x2713; |
| **Escape Sequences**                  | `\t`, `\\+`, `\?`                                       | &#x2713; |
| **Grouped Exps.**                     |                                                         |          |
| &emsp;&nbsp;_**Assertions**_          |                                                         |          |
| &emsp;&emsp;_Lookahead_               | `(?=abc)`                                               | &#x2713; |
| &emsp;&emsp;_Negative Lookahead_      | `(?!abc)`                                               | &#x2713; |
| &emsp;&emsp;_Lookbehind_              | `(?<=abc)`                                              | &#x2713; |
| &emsp;&emsp;_Negative Lookbehind_     | `(?<!abc)`                                              | &#x2713; |
| &emsp;&nbsp;_**Atomic**_              | `(?>abc)`                                               | &#x2713; |
| &emsp;&nbsp;_**Back-references**_     |                                                         |          |
| &emsp;&emsp;_Named_                   | `\k<name>`                                              | &#x2713; |
| &emsp;&emsp;_Nest Level_              | `\k<n-1>`                                               | &#x2713; |
| &emsp;&emsp;_Numbered_                | `\k<1>`                                                 | &#x2713; |
| &emsp;&emsp;_Relative_                | `\k<-2>`                                                | &#x2713; |
| &emsp;&emsp;_Traditional_             | `\1` thru `\9`                                          | &#x2713; |
| &emsp;&nbsp;_**Capturing**_           | `(abc)`                                                 | &#x2713; |
| &emsp;&nbsp;_**Comments**_            | `(?# comment text)`                                     | &#x2713; |
| &emsp;&nbsp;_**Named**_               | `(?<name>abc)`, `(?'name'abc)`                          | &#x2713; |
| &emsp;&nbsp;_**Options**_             | `(?mi-x:abc)`, `(?a:\s\w+)`                             | &#x2713; |
| &emsp;&nbsp;_**Passive**_             | `(?:abc)`                                               | &#x2713; |
| &emsp;&nbsp;_**Subexp. Calls**_       | `\g<name>`, `\g<1>`                                     | &#x2713; |
| **Keep**                              | `\K`, `(ab\Kc|d\Ke)f`                                   | &#x2713; |
| **Literals**                          | `Ruby`, `Cats?`                                         | &#x2713; |
| **POSIX Classes**                     | `[:alpha:]`, `[:^digit:]`                               | &#x2713; |
| **Quantifiers**                       |                                                         |          |
| &emsp;&nbsp;_**Greedy**_              | `?`, `*`, `+`, `{m,M}`                                  | &#x2713; |
| &emsp;&nbsp;_**Reluctant** (Lazy)_    | `??`, `*?`, `+?`, `{m,M}?`                              | &#x2713; |
| &emsp;&nbsp;_**Possessive**_          | `?+`, `*+`, `++`, `{m,M}+`                              | &#x2713; |
| **String Escapes**                    |                                                         |          |
| &emsp;&nbsp;_**Control**_             | `\C-C`, `\cD`                                           | &#x2713; |
| &emsp;&nbsp;_**Hex**_                 | `\x20`, `\x{701230}`                                    | &#x2713; |
| &emsp;&nbsp;_**Meta**_                | `\M-c`, `\M-\C-C`                                       | &#x2713; |
| &emsp;&nbsp;_**Octal**_               | `\0`, `\01`, `\012`                                     | &#x2713; |
| &emsp;&nbsp;_**Unicode**_             | `\uHHHH`, `\u{H+ H+}`                                   | &#x2713; |
| **Unicode Properties**                |                                                         |          |
| &emsp;&nbsp;_**Age**_                 | `\p{Age=5.2}`, `\P{age=7.0}`                            | &#x2713; |
| &emsp;&nbsp;_**Classes**_             | `\p{Alpha}`, `\P{Space}`                                | &#x2713; |
| &emsp;&nbsp;_**Derived**_             | `\p{Math}`, `\P{Lowercase}`                             | &#x2713; |
| &emsp;&nbsp;_**General Categories**_  | `\p{Lu}`, `\P{Cs}`                                      | &#x2713; |
| &emsp;&nbsp;_**Scripts**_             | `\p{Arabic}`, `\P{Hiragana}`                            | &#x2713; |
| &emsp;&nbsp;_**Simple**_              | `\p{Dash}`, `\p{Extender}`                              | &#x2713; |



<br/>
##### Inapplicable Features

Some modifiers, like `o` and `s`, apply to the **Regexp** object itself and do not
appear in its source. Others such modifiers include the encoding modifiers `e` and `n`
[[See]](http://www.ruby-doc.org/core-2.1.3/Regexp.html#class-Regexp-label-Encoding).
These are not seen by the scanner.


The following features are not currently enabled for Ruby by its regular
expressions library (Onigmo). They are not supported by the scanner.

  - **Quotes**: `\Q...\E` _<a href="https://github.com/k-takata/Onigmo/blob/master/doc/RE#L452/" title="Links to master branch, may change">[See]</a>_
  - **Capture History**: `(?@...)`, `(?@<name>...)` _<a href="https://github.com/k-takata/Onigmo/blob/master/doc/RE#L499" title="Links to master branch, may change">[See]</a>_


See something else missing? Please submit an [issue](https://github.com/ammar/regexp_parser/issues)

_**Note**: Attempting to process expressions with syntax features not supported
by the scanner will raise an error._


## Testing
To run the tests simply run rake from the root directory, as 'test' is the default task.

In addition to the main test task, which runs all tests, there are also component specific test
tasks, which only run the tests for one component at a time. These are:

* test:scanner
* test:lexer
* test:parser
* test:expression
* test:syntax

_A special task 'test:full' generates the scanner's code from the ragel source files and
runs all the tests. This task requires ragel to be installed._


The tests use ruby's test/unit, so they can also be run with:

```
ruby -Ilib test/test_all.rb
```

This is useful when there is a need to focus on specific test files, for example:

```
ruby -Ilib test/scanner/test_properties.rb
```

It is sometimes helpful during development to focus on a specific test case, for example:

```
ruby -Ilib test/expression/test_base.rb -n test_expression_to_re
```


## Building
Building the scanner and the gem requires [ragel](http://www.complang.org/ragel/) to be
installed. The build tasks will automatically invoke the 'ragel:rb' task to generate the
ruby scanner code.


The project uses the standard rubygems package tasks, so:


To build the gem in the pkg directory, run:
```
rake build
```

To install the gem from the cloned project, run:
```
rake install
```


## References
Documentation and books used while working on this project.


#### Ruby Flavors
* Oniguruma Regular Expressions (Ruby 1.9.x) [link](http://www.geocities.jp/kosako3/oniguruma/doc/RE.txt)
* Onigmo Regular Expressions (Ruby >= 2.0) [link](https://github.com/k-takata/Onigmo/blob/master/doc/RE)


#### Regular Expressions
* Mastering Regular Expressions, By Jeffrey E.F. Friedl (2nd Edition) [book](http://oreilly.com/catalog/9781565922570/)
* Regular Expression Flavor Comparison [link](http://www.regular-expressions.info/refflavors.html)
* Enumerating the strings of regular languages [link](http://www.cs.dartmouth.edu/~doug/nfa.ps.gz)
* Stack Overflow Regular Expressions FAQ [link](http://stackoverflow.com/questions/22937618/reference-what-does-this-regex-mean/22944075#22944075)


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
