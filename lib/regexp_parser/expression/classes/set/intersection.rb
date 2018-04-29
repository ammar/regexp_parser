module Regexp::Expression
  class CharacterSet < Regexp::Expression::Subexpression
    class Intersection < Regexp::Expression::CharacterSet::BinaryExpression
      def <<(exp)
        if count == 0 && exp.type == :set && exp.token == :open ||
           count == 1 && exp.type == :set && exp.token == :close
          raise '&& at set boundaries is a currently unsupported edge case'
        end
        super
      end
    end
  end
end
