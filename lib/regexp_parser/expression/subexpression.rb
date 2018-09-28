module Regexp::Expression

  class Subexpression < Regexp::Expression::Base
    include Enumerable

    attr_accessor :expressions

    def initialize(token, options = {})
      super

      self.expressions = []
    end

    # Override base method to clone the expressions as well.
    def initialize_clone(other)
      other.expressions = expressions.map(&:clone)
      super
    end

    def <<(exp)
      if exp.is_a?(WhiteSpace) && last && last.is_a?(WhiteSpace)
        last.merge(exp)
      else
        exp.nesting_level = nesting_level + 1
        expressions << exp
      end
    end

    %w[[] at each empty? fetch index join last length values_at].each do |method|
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{method}(*args, &block)
          expressions.#{method}(*args, &block)
        end
      RUBY
    end

    def dig(*indices)
      exp = self
      indices.each { |idx| exp = exp.nil? || exp.terminal? ? nil : exp[idx] }
      exp
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
      attributes.merge({
        text:        to_s(:base),
        expressions: expressions.map(&:to_h)
      })
    end
  end
end
