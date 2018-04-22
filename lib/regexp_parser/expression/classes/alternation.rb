module Regexp::Expression

  # This is not a subexpression really, but considering it one simplifies
  # the API when it comes to handling the alternatives.
  class Alternation < Regexp::Expression::Subexpression
    alias :alternatives :expressions

    def starts_at
      expressions.first.starts_at
    end
    alias :ts :starts_at

    def <<(exp)
      expressions.last << exp
    end

    def alternative(exp = nil)
      expressions << (exp ? exp : Alternative.new(level, set_level, conditional_level))
    end

    def quantify(token, text, min = nil, max = nil, mode = :greedy)
      alternatives.last.last.quantify(token, text, min, max, mode)
    end

    def to_s(format = :full)
      alternatives.map{|e| e.to_s(format)}.join('|')
    end
  end

  # A sequence of expressions, used by Alternation as one of its alternative.
  class Alternative < Regexp::Expression::Sequence; end

end
