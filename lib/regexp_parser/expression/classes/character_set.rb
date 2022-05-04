module Regexp::Expression
  class CharacterSet < Regexp::Expression::Subexpression
    attr_accessor :closed, :negative

    alias :negative? :negative
    alias :negated?  :negative
    alias :closed?   :closed

    def initialize(token, options = {})
      self.negative = false
      self.closed   = false
      super
    end

    def negate
      self.negative = true
    end

    def close
      self.closed = true
    end

    def to_s(format = :full)
      [text, (negated? ? '^' : ''), *expressions,
       terminator_text, quantifier_affix(format)].join
    end

    def terminator_text
      ']'
    end
  end
end # module Regexp::Expression
