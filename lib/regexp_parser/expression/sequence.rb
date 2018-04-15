module Regexp::Expression

  # A sequence of expressions. Differs from a Subexpressions by how it handles
  # quantifiers, as it applies them to its last element instead of itself as
  # a whole subexpression.
  #
  # Used as the base class for the Alternation alternatives and Conditional
  # branches.
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
      expressions.first.starts_at
    end
    alias :ts :starts_at

    def quantify(token, text, min = nil, max = nil, mode = :greedy)
      offset = -1
      target = expressions[offset]
      while target.is_a?(FreeSpace)
        target = expressions[offset -= 1]
      end

      target || raise(ArgumentError, "No valid target found for '#{text}' "\
                                     'quantifier')

      target.quantify(token, text, min, max, mode)
    end
  end

end
