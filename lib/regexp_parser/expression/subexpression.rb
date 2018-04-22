module Regexp::Expression

  class Subexpression < Regexp::Expression::Base
    attr_accessor :expressions

    def initialize(token, options = {})
      super

      self.expressions = []
    end

    # Override base method to clone the expressions as well.
    def clone
      copy = super
      copy.expressions = expressions.map(&:clone)
      copy
    end

    def <<(exp)
      if exp.is_a?(WhiteSpace) && last && last.is_a?(WhiteSpace)
        last.merge(exp)
      else
        expressions << exp
      end
    end

    def insert(exp)
      expressions.insert(0, exp)
    end

    %w[[] all? any? at count each each_with_index empty?
       fetch find first index join last length values_at].each do |m|
      define_method(m) { |*args, &block| expressions.send(m, *args, &block) }
    end

    def te
      ts + to_s.length
    end

    def to_s(format = :full)
      # Note: the format does not get passed down to subexpressions.
      # Note: cant use #text accessor, b/c it is overriden as def text; to_s end
      # in Expression::Sequence, causing infinite recursion. Clean-up needed.
      "#{@text}#{expressions.join}#{quantifier_affix(format)}"
    end

    def to_h
      super.merge({
        text:        to_s(:base),
        expressions: expressions.map(&:to_h)
      })
    end
  end
end
