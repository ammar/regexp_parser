module Regexp::Parser
  module Expression

    class Group < Expression::Base
      attr_reader :expressions

      def initialize(type, token, text)
        super
        @expressions = []
      end

      def <<(exp)
        @expressions << exp
      end

      def capturing?
        @token == :capture
      end

      class Comment < Expression::Group; end

      class Capture < Expression::Group; end
      class Passive < Expression::Group; end
      class Atomic < Expression::Group; end

      class Lookahead < Expression::Group; end
      class NegativeLookahead < Expression::Group; end
      class Lookbehind < Expression::Group; end
      class NegativeLookbehind < Expression::Group; end

      class Named < Expression::Group; end

      class Options < Expression::Group; end
    end

  end # module Expression
end # module Regexp::Parser
