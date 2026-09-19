# frozen_string_literal: true
#
# This file implements several tree traversal methods.
#
# Note: The methods are optimized for performance and avoid stack overflows on
#       large trees. Check tasks/benchmark/traversal.rb when working in here.
module Regexp::Expression
  class Subexpression < Regexp::Expression::Base

    # Traverses the expression, passing each recursive child to the
    # given block.
    # If the block takes two arguments, the indices of the children within
    # their parents are also passed to it.
    def each_expression(include_self = false, &block)
      return enum_for(__method__, include_self) unless block

      if block.arity == 1
        block.call(self) if include_self
        each_expression_without_index(&block)
      else
        block.call(self, 0) if include_self
        each_expression_with_index(&block)
      end
    end

    # Traverses the subexpression (depth-first, pre-order) and calls the given
    # block for each expression with three arguments; the traversal event,
    # the expression, and the index of the expression within its parent.
    #
    # The event argument is passed as follows:
    #
    # - For subexpressions, :enter upon entering the subexpression, and
    #   :exit upon exiting it.
    #
    # - For terminal expressions, :visit is called once.
    #
    # Returns self.
    def traverse(include_self = false, &block)
      return enum_for(__method__, include_self) unless block_given?

      block.call(:enter, self, 0) if include_self

      stack = []
      parent, children, index = self, expressions, 0

      loop do
        while (exp = children[index])
          if exp.terminal?
            block.call(:visit, exp, index)
            index += 1
          else
            block.call(:enter, exp, index)
            # Resume at this child to emit its exit event after descending.
            stack.push(parent, index)
            parent, children, index = exp, exp.expressions, 0
          end
        end

        break if stack.empty?

        exp = parent
        index = stack.pop
        parent = stack.pop
        children = parent.expressions
        block.call(:exit, exp, index)
        index += 1
      end

      block.call(:exit, self, 0) if include_self

      self
    end
    alias :walk :traverse

    # Returns a new array with the results of calling the given block once
    # for every expression. If a block is not given, returns an array with
    # each expression and its level index as an array.
    def flat_map(include_self = false, &block)
      case block && block.arity
      when nil then each_expression(include_self).to_a
      when 2   then each_expression(include_self).map(&block)
      else          each_expression(include_self).map { |exp| block.call(exp) }
      end
    end

    protected

    def each_expression_with_index(&block)
      stack = []
      children, index = expressions, 0

      loop do
        while (exp = children[index])
          block.call(exp, index)
          index += 1
          unless exp.terminal?
            # Resume at the next sibling after visiting this child's subtree.
            stack.push(children, index)
            children, index = exp.expressions, 0
          end
        end

        break if stack.empty?

        index = stack.pop
        children = stack.pop
      end
    end

    def each_expression_without_index(&block)
      queue = expressions.reverse

      until queue.empty?
        exp = queue.pop
        block.call(exp)
        queue.concat(exp.expressions.reverse) unless exp.terminal?
      end
    end
  end
end
