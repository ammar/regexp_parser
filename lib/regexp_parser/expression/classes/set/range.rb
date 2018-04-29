module Regexp::Expression
  class CharacterSet < Regexp::Expression::Subexpression
    class Range < Regexp::Expression::CharacterSet::BinaryExpression
    end
  end
end
