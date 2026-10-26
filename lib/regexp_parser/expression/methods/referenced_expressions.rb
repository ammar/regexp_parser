# frozen_string_literal: true

module Regexp::Expression
  class Base
    def referenced_expression
      referenced_expressions.first
    end

    # Find referenced expressions. E.g. if this is a Backreference::Number,
    # find the Group::Capture instance that it refers to via its number.
    def referenced_expressions
      result = []
      return result unless referential? && parent

      find_root.each_expression(true) do |exp|
        result << exp if exp.referable? && exp.identifier == reference
      end
      result
    end
  end
end
