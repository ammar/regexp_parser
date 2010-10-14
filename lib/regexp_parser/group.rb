module Regexp::Parser
  class Expression

    class Group < Expression::Base
      attr_reader :expressions

      def initialize(*args)
        @expressions = []
        super
      end

      def type; :group end

      def << exp; @expressions << exp end

      def capturing?
        type == :group
      end
    end

    class Comment < Expression::Group
      def type; :comment end

      def initialize(*args)
        super(*args)
      end
    end

    class PassiveGroup < Expression::Group
      def type; :passive_group end

      def initialize(*args)
        super(*args)
      end
    end

    class AtomicGroup < Expression::Group
      def type; :atomic_group end

      def initialize(*args)
        super(*args)
      end
    end

    class Lookahead < Expression::Group
      def type; :lookahead end

      def initialize(*args)
        super(*args)
      end
    end

    class NegativeLookahead < Expression::Group
      def type; :nlookahead end

      def initialize(*args)
        super(*args)
      end
    end

    class Lookbehind < Expression::Group
      def type; :lookbehind end

      def initialize(*args)
        super(*args)
      end
    end

    class NegativeLookbehind < Expression::Group
      def type; :nlookbehind end

      def initialize(*args)
        super(*args)
      end
    end

    class Options < Expression::Group
      def type; :options end

      def initialize(*args)
        super(*args)
      end
    end

    class NamedGroup < Expression::Group
      def type; :named_group end

      def initialize(*args)
        super(*args)
      end
    end

  end # class Expression
end # module Regexp::Parser
