module Regexp::Expression

  module Conditional
    class TooManyBranches < StandardError
      def initialize
        super('The conditional expression has more than 2 branches')
      end
    end

    class Condition < Regexp::Expression::Base; end
    class Branch    < Regexp::Expression::Sequence; end

    class Expression < Regexp::Expression::Subexpression
      attr_reader :branches, :condition

      def initialize(token, options = {})
        super
        @branches  = []
      end

      def condition=(exp)
        @condition = exp
        expressions << exp
      end

      def <<(exp)
        expressions.last << exp
      end

      def branch(exp = nil)
        raise TooManyBranches.new if branches.length == 2

        sequence = Branch.new(level, set_level, conditional_level + 1)

        expressions << sequence
        branches << expressions.last
      end

      def quantify(token, text, min = nil, max = nil, mode = :greedy)
        branches.last.last.quantify(token, text, min, max, mode)
      end

      def to_s(_format = :full)
        text + condition.text + branches.join('|') + ')'
      end
    end
  end

end
