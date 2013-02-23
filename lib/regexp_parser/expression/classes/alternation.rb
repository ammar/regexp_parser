module Regexp::Expression

  # This is not a subexpression really, but considering it one simplifies
  # the API when it comes to handling the alternatives.
  class Alternation < Regexp::Expression::Subexpression
    def starts_at
      @expressions.first.starts_at
    end

    def <<(exp)
      @expressions.last << exp
    end

    def alternative(exp = nil)
      @expressions << (exp ? exp : Sequence.new)
    end

    def alternatives
      @expressions
    end

    def quantify(token, text, min = nil, max = nil, mode = :greedy)
      alternatives.last.last.quantify(token, text, min, max, mode)
    end

    def to_s(format = :full)
      alternatives.map{|e| e.to_s(format)}.join('|')
    end
  end

  # A sequence of expressions, used by alternations as one alternative.
  # TODO: perhaps rename this to Alternative?
  class Sequence < Regexp::Expression::Subexpression
    def initialize
      super Regexp::Token.new(:expression, :sequence, '')
    end

    def starts_at
      @expressions.first.starts_at
    end

    def quantify(token, text, min = nil, max = nil, mode = :greedy)
      last.quantify(token, text, min, max, mode)
    end
  end

end
