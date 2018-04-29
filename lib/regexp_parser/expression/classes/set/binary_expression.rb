module Regexp::Expression
  class CharacterSet < Regexp::Expression::Subexpression
    # abstract class
    class BinaryExpression < Regexp::Expression::Subexpression
      def starts_at
        expressions.first.starts_at
      end
      alias :ts :starts_at

      def <<(exp)
        complete? && raise("Can't add another expression to #{self.class}")
        exp.in_binary_set_expression = true
        super
      end

      def complete?
        count == 2
      end

      def to_s(_format = :full)
        "#{expressions[0]}#{text}#{expressions[1]}"
      end
    end
  end
end
