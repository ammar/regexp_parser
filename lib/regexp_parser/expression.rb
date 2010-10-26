module Regexp::Parser

  module Expression
    class Base
      attr_reader :type, :token, :text
      attr_reader :quantifier, :min, :max
      attr_reader :expressions

      attr_accessor :options

      def initialize(type, token, text)
        @type         = type
        @token        = token
        @text         = text
        @options      = nil
        @expressions  = []
      end

      #def to_s
      #  @text
      #end

      def <<(exp)
        @expressions << exp
      end

      def quantify(quantifier, min = nil, max = nil, mode = :greedy)
        @quantifier = quantifier
        @min, @max  = min, max
        @quantifier_mode = mode
      end

      def quantified?
        not @quantifier.nil?
      end

      def quantifier_mode
        @quantifier_mode
      end

      def quantity
        [@min, @max]
      end

      def reluctant?
        @quantifier_mode == :reluctant
      end

      def possessive?
        @quantifier_mode == :possessive
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

    class Root < Expression::Base
      def initialize
        super(:expression, :root, '')
      end
    end

    class Literal < Expression::Base; end

    class CharacterSet < Expression::Base
      attr_accessor :members

      def initialize(type, token, text)
        @members = []
        @negative = false
        super
      end

      def <<(member)
        @members << member
      end

      def negate
        @negative = true
      end

      def negative?
        @negative
      end
      alias :negated? :negative?
    end

    class Anchor < Expression::Base
      class BeginningOfLine               < Anchor; end
      class EndOfLine                     < Anchor; end

      class BeginningOfString             < Anchor; end
      class EndOfString                   < Anchor; end

      class EndOfStringOrBeforeEndOfLine  < Anchor; end

      class WordBoundary                  < Anchor; end
      class NonWordBoundary               < Anchor; end

      BOL      = BeginningOfLine 
      EOL      = EndOfLine 
      BOS      = BeginningOfString
      EOS      = EndOfString
      EOSobEOL = EndOfStringOrBeforeEndOfLine
    end

    class CharacterType < Expression::Base
      class Any         < CharacterType; end
      class Digit       < CharacterType; end
      class NonDigit    < CharacterType; end
      class Hex         < CharacterType; end
      class NonHex      < CharacterType; end
      class Word        < CharacterType; end
      class NonWord     < CharacterType; end
      class Space       < CharacterType; end
      class NonSpace    < CharacterType; end
    end

    module CharacterProperty 
      class Base < Expression::Base
        def inverted?
          @type == :nonproperty
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
      class Print         < Base; end
      class Punct         < Base; end
      class Space         < Base; end
      class Upper         < Base; end
      class Word          < Base; end
      class Xdigit        < Base; end

      class Letter  < CharacterProperty::Base
        class Any         < Letter; end
        class Uppercase   < Letter; end
        class Lowercase   < Letter; end
        class Titlecase   < Letter; end
        class Modifier    < Letter; end
        class Other       < Letter; end
      end

      class Mark  < CharacterProperty::Base
        class Any         < Mark; end
        class Nonspacing  < Mark; end
        class Spacing     < Mark; end
        class Enclosing   < Mark; end
      end

      class Number  < CharacterProperty::Base
        class Any         < Number; end
        class Decimal     < Number; end
        class Letter      < Number; end
        class Other       < Number; end
      end

      class Punctuation  < CharacterProperty::Base
        class Any         < Punctuation; end
        class Connector   < Punctuation; end
        class Dash        < Punctuation; end
        class Open        < Punctuation; end
        class Close       < Punctuation; end
        class Initial     < Punctuation; end
        class Final       < Punctuation; end
        class Other       < Punctuation; end
      end

      class Separator  < CharacterProperty::Base
        class Any         < Separator; end
        class Space       < Separator; end
        class Line        < Separator; end
        class Paragraph   < Separator; end
      end

      class Symbol  < CharacterProperty::Base
        class Any         < Symbol; end
        class Math        < Symbol; end
        class Currency    < Symbol; end
        class Modifier    < Symbol; end
        class Other       < Symbol; end
      end

      class Codepoint  < CharacterProperty::Base
        class Any         < Codepoint; end
        class Control     < Codepoint; end
        class Format      < Codepoint; end
        class Surrogate   < Codepoint; end
        class PrivateUse  < Codepoint; end
        class Unassigned  < Codepoint; end
      end
    end

    # TODO: split this into escape sequences and string escapes
    class EscapeSequence < Expression::Base
      class Literal       < CharacterType; end
      class Tab           < CharacterType; end
      class VerticalTab   < CharacterType; end
      class Newline       < CharacterType; end
      class Return        < CharacterType; end
      class Backspace     < CharacterType; end
      class FormFeed      < CharacterType; end
      class Bell          < CharacterType; end
      class Escape        < CharacterType; end
      class Octal         < CharacterType; end
      class Hex           < CharacterType; end
      class HexWide       < CharacterType; end
      class Control       < CharacterType; end
      class Meta          < CharacterType; end
      class MetaControl   < CharacterType; end
    end

    class Alternation < Expression::Base
      def <<(exp)
        if @expressions.last.is_a?(Literal) and exp.is_a?(Literal)
          seq = Expression::Sequence.new
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

    end

    class Sequence < Expression::Base
      def initialize
        super(:expression, :sequence, '')
      end

      def <<(exp)
        @expressions.insert 0, exp
      end
    end

    class Group < Expression::Base
      def capturing?
        [:capture, :named].include? @token
      end

      def comment?
        @token == :comment
      end

      class Comment   < Expression::Group; end

      class Atomic    < Expression::Group; end
      class Capture   < Expression::Group; end
      class Named     < Expression::Group; end
      class Passive   < Expression::Group; end
      class Options   < Expression::Group; end
    end

    class Assertion < Expression::Group
      class Lookahead           < Expression::Assertion; end
      class NegativeLookahead   < Expression::Assertion; end
      class Lookbehind          < Expression::Assertion; end
      class NegativeLookbehind  < Expression::Assertion; end
    end

  end # module Expression
end # module Regexp::Parser
