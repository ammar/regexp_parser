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
      attr_reader :condition

      def condition=(exp)
        @condition = exp
        expressions << exp
      end

      def <<(exp)
        expressions.last << exp
      end

      def add_sequence
        raise TooManyBranches.new if branches.length == 2
        Branch.add_to(self, { conditional_level: conditional_level + 1 })
      end
      alias :branch :add_sequence

      def branches
        expressions - [condition]
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
