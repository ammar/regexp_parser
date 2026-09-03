# frozen_string_literal: true

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

      pending = []
      push_children(pending, self)

      until pending.empty?
        event, exp, index = pending.pop
        if event == :exit
          block.call(:exit, exp, index)
        elsif exp.terminal?
          block.call(:visit, exp, index)
        else
          block.call(:enter, exp, index)
          pending << [:exit, exp, index]
          push_children(pending, exp)
        end
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
      pending = []
      push_children(pending, self, false)

      until pending.empty?
        exp, index = pending.pop
        block.call(exp, index)
        push_children(pending, exp, false) unless exp.terminal?
      end
    end

    def each_expression_without_index(&block)
      pending = expressions.reverse

      until pending.empty?
        exp = pending.pop
        block.call(exp)
        pending.concat(exp.expressions.reverse) unless exp.terminal?
      end
    end

    def push_children(pending, parent, with_event = true)
      index = parent.length
      while index > 0
        index -= 1
        child = parent[index]
        pending << (with_event ? [:enter, child, index] : [child, index])
      end
    end
  end
end
