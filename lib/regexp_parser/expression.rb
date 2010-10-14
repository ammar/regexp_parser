module Regexp::Parser

  class Expression
    class Base
      attr_reader :start, :end, :text
      attr_reader :quantifier, :min, :max
      attr_accessor :options

      def initialize(text, ts, te)
        @text     = text[ts..te-1].pack("c*")
        @start    = ts
        @end      = te
        @options  = nil
      end

      def quantify(quantifier, min = nil, max = nil, mode = :basic)
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

      def extended?
        (@options and @options[:x]) ? true : false
      end
      alias :x? :extended?
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

    class Literal < Expression::Base
      def type; :literal end
    end

    class Anchor < Expression::Base
      def initialize(text, ts, te)
        case text[ts, te].pack('c*')
        when '^'
          @type = :beginning_of_line
        when '$'
          @type = :end_of_line
        else
          @type = :anchor
        end
      end

      def type; @type end
    end

    class CharacterSet < Expression::Base
      def type; :character_set end
    end

    class CharacterType < Expression::Base
      def type; :character_type end
    end

    class Alternation < Expression::Base
      def initialize(text, ts, te)
        @alternatives = []
      end

      def type; :alternation end

      def <<(exp)
        @alternatives << exp
      end
    end

  end # class Expression
end # module Regexp::Parser
