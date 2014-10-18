module Regexp::Expression

  # A sequence of expressions
  class Sequence < Regexp::Expression::Subexpression
    def initialize(level, set_level, conditional_level)
      super Regexp::Token.new(
        :expression,
        :sequence,
        '',
        nil, # ts
        nil, # te
        level,
        set_level,
        conditional_level
      )
    end

    def text
      to_s
    end

    def starts_at
      @expressions.first.starts_at
    end

    def quantify(token, text, min = nil, max = nil, mode = :greedy)
      last.quantify(token, text, min, max, mode)
    end
  end

end
