# frozen_string_literal: true

module Regexp::Expression
  class Subexpression < Regexp::Expression::Base
    include Enumerable

    attr_accessor :expressions

    def initialize(token, options = {})
      self.expressions = []
      super
    end

    # Override base method to clone the expressions as well.
    def initialize_copy(orig)
      super
      self.expressions = orig.expressions.map do |exp|
        exp.clone.tap { |copy| copy.parent = self }
      end
    end

    def <<(exp)
      exp.parent = self
      expressions << exp
    end

    %w[[] at each empty? fetch index join last length values_at zip].each do |method|
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
      ts + base_length
    end

    def to_h
      attributes.merge(
        text:        to_s(:base),
        expressions: expressions.map(&:to_h)
      )
    end

    # Find the expression targeted by this quantifier, ignoring decorations
    # in between the two (e.g. whitespace in x-mode).
    def extract_quantifier_target(quantifier_description)
      target = expressions.reverse_each.find { |exp| !exp.decorative? }
      target or raise Regexp::Parser::ParserError,
        "No valid target found for '#{quantifier_description}' quantifier"

      target
    end
  end
end
