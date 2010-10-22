module Regexp::Parser

  module Expression
    class Base
      attr_reader :type, :token, :text
      attr_reader :quantifier, :min, :max

      attr_accessor :options

      def initialize(type, token, text)
        @type     = type
        @token    = token
        @text     = text
        @options  = nil
      end

      #def to_s
      #  @text
      #end

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

      def reluctant?
        @quantifier_mode == :reluctant
      end

      def possessive?
        @quantifier_mode == :possessive
      end

      def multi_line?
        (@options and @options[:m]) ? true : false
      end
      alias :m? :multi_line?

      def case_insensitive?
        (@options and @options[:i]) ? true : false
      end
      alias :i? :case_insensitive?

      def free_spacing?
        (@options and @options[:x]) ? true : false
      end
      alias :x? :free_spacing?
    end

    class Root < Expression::Base
      attr_reader :expressions

      def initialize
        @expressions = []
      end

      def <<(exp)
        @expressions << exp
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
      class BeginningOfLine < Anchor; end
      class EndOfLine < Anchor; end
      class BeginningOfString < Anchor; end
      class EndOfString < Anchor; end
      class EndOfStringOrBeforeEndOfLine < Anchor; end

      BOL = BeginningOfLine 
      EOL = EndOfLine 
      BOS = BeginningOfString
      EOS = EndOfString
      EOSOrBeforeEOL = EndOfStringOrBeforeEndOfLine

      class WordBoundary < Anchor; end
      class NonWordBoundary < Anchor; end
    end

    class CharacterType < Expression::Base
      class Any < CharacterType; end
      class Digit < CharacterType; end
      class NonDigit < CharacterType; end
      class Hex < CharacterType; end
      class NonHex < CharacterType; end
      class Word < CharacterType; end
      class NonWord < CharacterType; end
      class Space < CharacterType; end
      class NonSpace < CharacterType; end
    end

    class CharacterProperty 
      class Base < Expression::Base
        def inverted?
          @type == :inverted_property
        end
      end

      class Alnum   < CharacterProperty::Base; end
      class Alpha   < CharacterProperty::Base; end
      class Any     < CharacterProperty::Base; end
      class Ascii   < CharacterProperty::Base; end
      class Blank   < CharacterProperty::Base; end
      class Cntrl   < CharacterProperty::Base; end
      class Digit   < CharacterProperty::Base; end
      class Graph   < CharacterProperty::Base; end
      class Lower   < CharacterProperty::Base; end
      class Print   < CharacterProperty::Base; end
      class Punct   < CharacterProperty::Base; end
      class Space   < CharacterProperty::Base; end
      class Upper   < CharacterProperty::Base; end
      class Word    < CharacterProperty::Base; end
      class Xdigit  < CharacterProperty::Base; end
    end

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
      def initialize(text, ts, te)
        @alternatives = []
      end

      def <<(exp)
        @alternatives << exp
      end
    end

  end # module Expression
end # module Regexp::Parser

require File.expand_path('../group', __FILE__)
