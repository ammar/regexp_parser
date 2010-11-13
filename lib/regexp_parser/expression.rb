module Regexp::Expression
  class Base
    attr_reader :type, :token, :text
    attr_reader :quantifier, :min, :max
    attr_reader :expressions

    attr_accessor :options

    def initialize(token)
      @type         = token.type
      @token        = token.token
      @text         = token.text
      @options      = nil
      @expressions  = []
    end

    def to_s
      s = @text
      s << @quantifier if quantified?
      s
    end

    def <<(exp)
      @expressions << exp
    end

    def quantify(token, text, min = nil, max = nil, mode = :greedy)
      @quantifier = Quantifier.new(token, text, min, max, mode)
    end

    def quantified?
      not @quantifier.nil?
    end

    def quantity
      [@quantifier.min, @quantifier.max]
    end

    def greedy?
      @quantifier.mode == :greedy
    end

    def reluctant?
      @quantifier.mode == :reluctant
    end

    def possessive?
      @quantifier.mode == :possessive
    end

    def multiline?
      (@options and @options[:m]) ? true : false
    end
    alias :m? :multiline?

    def insensitive?
      (@options and @options[:i]) ? true : false
    end
    alias :i? :insensitive?

    def free_spacing?
      (@options and @options[:x]) ? true : false
    end
    alias :x? :free_spacing?
  end

  class Root < Regexp::Expression::Base
    def initialize
      super Regexp::Token.new(:expression, :root, '')
    end

    def to_s
      @expressions.join
    end
  end

  class Quantifier
    attr_reader :token, :text, :min, :max, :mode

    def initialize(token, text, min, max, mode)
      @token = token
      @text  = text
      @mode  = mode
      @min   = min
      @max   = max
    end

    def to_s
      @text
    end
    alias :to_str :to_s
  end

  class Literal < Regexp::Expression::Base; end

  class CharacterSet < Regexp::Expression::Base
    attr_accessor :members

    def initialize(token)
      @members = []
      @negative = false
      super
    end

    def <<(member)
      if member.length == 1
        @members << member
      elsif member =~ /\\./
        @members << member
      elsif member =~ /\[:(\w+):\]/
        case $1
        when 'alnum';   CType::Alnum.each  {|c| @members << c }
        when 'alpha';   CType::Alpha.each  {|c| @members << c }
        when 'blank';   CType::Blank.each  {|c| @members << c }
        when 'cntrl';   CType::Cntrl.each  {|c| @members << c }
        when 'digit';   CType::Digit.each  {|c| @members << c }
        when 'graph';   CType::Graph.each  {|c| @members << c }
        when 'lower';   CType::Lower.each  {|c| @members << c }
        when 'print';   CType::Print.each  {|c| @members << c }
        when 'punct';   CType::Punct.each  {|c| @members << c }
        when 'space';   CType::Space.each  {|c| @members << c }
        when 'upper';   CType::Upper.each  {|c| @members << c }
        when 'xdigit';  CType::XDigit.each {|c| @members << c }
        when 'word';    CType::Word.each   {|c| @members << c }
        when 'ascii';   CType::ASCII.each  {|c| @members << c }
        else
          raise "Unexpected posix class name '#{$1}' character set member"
        end
      elsif member =~ /\[.([\w-]+).\]/
        # TODO: add collation sequences
      elsif member =~ /\[=(\w+)=\]/
        # TODO: add character equivalents
      else
        raise "Unexpected character set member '#{member}'"
      end

      @members.uniq!
    end

    def include?(member)
      @members.include? member
    end

    def negate
      @negative = true
    end

    def negative?
      @negative
    end
    alias :negated? :negative?

    def to_s
      s = @text
      s << '^' if negative?
      s << @members.join
      s << @quantifier.to_s if quantified?
      s
    end
  end

  module Anchor
    class Base < Regexp::Expression::Base; end

    class BeginningOfLine               < Anchor::Base; end
    class EndOfLine                     < Anchor::Base; end

    class BeginningOfString             < Anchor::Base; end
    class EndOfString                   < Anchor::Base; end

    class EndOfStringOrBeforeEndOfLine  < Anchor::Base; end

    class WordBoundary                  < Anchor::Base; end
    class NonWordBoundary               < Anchor::Base; end

    BOL      = BeginningOfLine 
    EOL      = EndOfLine 
    BOS      = BeginningOfString
    EOS      = EndOfString
    EOSobEOL = EndOfStringOrBeforeEndOfLine
  end

  module CharacterType
    class Base < Regexp::Expression::Base; end

    class Any         < CharacterType::Base; end
    class Digit       < CharacterType::Base; end
    class NonDigit    < CharacterType::Base; end
    class Hex         < CharacterType::Base; end
    class NonHex      < CharacterType::Base; end
    class Word        < CharacterType::Base; end
    class NonWord     < CharacterType::Base; end
    class Space       < CharacterType::Base; end
    class NonSpace    < CharacterType::Base; end
  end

  module CharacterProperty 
    class Base < Regexp::Expression::Base
      def inverted?
        @type == :nonproperty
      end

      def name
        @text[/[^\\pP{}]+/]
      end
    end

    class Alnum         < Base; end
    class Alpha         < Base; end
    class Any           < Base; end
    class Ascii         < Base; end
    class Blank         < Base; end
    class Cntrl         < Base; end
    class Digit         < Base; end
    class Graph         < Base; end
    class Lower         < Base; end
    class Newline       < Base; end
    class Print         < Base; end
    class Punct         < Base; end
    class Space         < Base; end
    class Upper         < Base; end
    class Word          < Base; end
    class Xdigit        < Base; end

    module Letter
      class Base < CharacterProperty::Base; end

      class Any         < Letter::Base; end
      class Uppercase   < Letter::Base; end
      class Lowercase   < Letter::Base; end
      class Titlecase   < Letter::Base; end
      class Modifier    < Letter::Base; end
      class Other       < Letter::Base; end
    end

    module Mark
      class Base < CharacterProperty::Base; end

      class Any         < Mark::Base; end
      class Nonspacing  < Mark::Base; end
      class Spacing     < Mark::Base; end
      class Enclosing   < Mark::Base; end
    end

    module Number
      class Base < CharacterProperty::Base; end

      class Any         < Number::Base; end
      class Decimal     < Number::Base; end
      class Letter      < Number::Base; end
      class Other       < Number::Base; end
    end

    module Punctuation
      class Base < CharacterProperty::Base; end

      class Any         < Punctuation::Base; end
      class Connector   < Punctuation::Base; end
      class Dash        < Punctuation::Base; end
      class Open        < Punctuation::Base; end
      class Close       < Punctuation::Base; end
      class Initial     < Punctuation::Base; end
      class Final       < Punctuation::Base; end
      class Other       < Punctuation::Base; end
    end

    module Separator
      class Base < CharacterProperty::Base; end

      class Any         < Separator::Base; end
      class Space       < Separator::Base; end
      class Line        < Separator::Base; end
      class Paragraph   < Separator::Base; end
    end

    module Symbol
      class Base < CharacterProperty::Base; end

      class Any         < Symbol::Base; end
      class Math        < Symbol::Base; end
      class Currency    < Symbol::Base; end
      class Modifier    < Symbol::Base; end
      class Other       < Symbol::Base; end
    end

    module Codepoint
      class Base < CharacterProperty::Base; end

      class Any         < Codepoint::Base; end
      class Control     < Codepoint::Base; end
      class Format      < Codepoint::Base; end
      class Surrogate   < Codepoint::Base; end
      class PrivateUse  < Codepoint::Base; end
      class Unassigned  < Codepoint::Base; end
    end

    class Age     < CharacterProperty::Base; end
    class Derived < CharacterProperty::Base; end
    class Script  < CharacterProperty::Base; end
  end

  # TODO: split this into escape sequences and string escapes
  module EscapeSequence
    class Base          < Regexp::Expression::Base; end

    class Literal       < EscapeSequence::Base; end

    class AsciiEscape   < EscapeSequence::Base; end
    class Backspace     < EscapeSequence::Base; end
    class Bell          < EscapeSequence::Base; end
    class FormFeed      < EscapeSequence::Base; end
    class Newline       < EscapeSequence::Base; end
    class Return        < EscapeSequence::Base; end
    class Space         < EscapeSequence::Base; end
    class Tab           < EscapeSequence::Base; end
    class VerticalTab   < EscapeSequence::Base; end

    class Octal         < EscapeSequence::Base; end
    class Hex           < EscapeSequence::Base; end
    class HexWide       < EscapeSequence::Base; end

    class Control       < EscapeSequence::Base; end
    class Meta          < EscapeSequence::Base; end
    class MetaControl   < EscapeSequence::Base; end
  end

  class Alternation < Regexp::Expression::Base
    def <<(exp)
      if @expressions.last.is_a?(Literal) and exp.is_a?(Literal)
        seq = Regexp::Expression::Sequence.new
        seq << exp
        seq << @expressions.pop
        @expressions << seq
      else
        @expressions << exp
      end
    end

    def alternatives
      @expressions
    end

    def quantify(token, text, min = nil, max = nil, mode = :greedy)
      if @expressions.last.is_a?(Sequence)
        @expressions.last.last.quantify(token, text, min, max, mode)
      else
        @expressions.last.quantify(token, text, min, max, mode)
      end
    end

    def to_s
      s = @expressions.map{|e| e.to_s}.join('|')
    end
  end

  # a sequence of expressions, used by alternations
  class Sequence < Regexp::Expression::Base
    def initialize
      super Regexp::Token.new(:expression, :sequence, '')
    end

    def <<(exp)
      @expressions.insert 0, exp
    end

    def to_s
      s = @expressions.map{|e| e.to_s}.join('|')
    end
  end

  module Group
    class Base < Regexp::Expression::Base
      def capturing?
        [:capture, :named].include? @token
      end

      def comment?; false end

      def to_s
        s = @text
        s << @expressions.join
        s << ')'
        s << @quantifier.to_s if quantified?
        s
      end
    end

    class Atomic    < Group::Base; end
    class Capture   < Group::Base; end
    class Named     < Group::Base; end
    class Passive   < Group::Base; end

    class Options   < Group::Base; end

    # special case inheritance, for to_s
    class Comment   < Regexp::Expression::Base
      def comment?; true end
    end
  end

  class Assertion
    class Base < Regexp::Expression::Group::Base; end

    class Lookahead           < Assertion::Base; end
    class NegativeLookahead   < Assertion::Base; end

    class Lookbehind          < Assertion::Base; end
    class NegativeLookbehind  < Assertion::Base; end
  end

end # module Regexp::Expression
