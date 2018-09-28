module Regexp::Expression
  module Conditional
    class TooManyBranches < StandardError
      def initialize
        super('The conditional expression has more than 2 branches')
      end
    end

    class Condition < Regexp::Expression::Base
      # Name or number of the referenced capturing group that determines state.
      # Returns a String if reference is by name, Integer if by number.
      def reference
        ref = text.tr("'<>()", "")
        ref =~ /\D/ ? ref : Integer(ref)
      end
    end

    class Branch < Regexp::Expression::Sequence; end

    class Expression < Regexp::Expression::Subexpression
      def <<(exp)
        expressions.last << exp
      end

      def add_sequence
        raise TooManyBranches.new if branches.length == 2
        Branch.add_to(self, { conditional_level: conditional_level + 1 })
      end
      alias :branch :add_sequence

      def condition=(exp)
        expressions.delete(condition)
        expressions.unshift(exp)
      end

      def condition
        find { |subexp| subexp.is_a?(Condition) }
      end

      def branches
        select { |subexp| subexp.is_a?(Sequence) }
      end

      def reference
        condition.reference
      end

      def to_s(format = :full)
        "#{text}#{condition}#{branches.join('|')})#{quantifier_affix(format)}"
      end
    end
  end
end
