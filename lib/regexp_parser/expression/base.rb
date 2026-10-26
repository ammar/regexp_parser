# frozen_string_literal: true

module Regexp::Expression
  class Base
    include Regexp::Expression::Shared

    def initialize(token, options = {})
      init_from_token_and_options(token, options)
    end

    def to_re(format = :full)
      if set_level > 0
        warn "Calling #to_re on character set members is deprecated - "\
             "their behavior might not be equivalent outside of the set."
      end
      ::Regexp.new(to_s(format))
    end

    # Returns the root expression of the current expression. This will be a
    # Regexp::Expression::Root, unless called on a manually constructed node.
    def find_root
      exp = self
      exp = exp.parent until exp.parent.nil?
      exp
    end

    def to_h
      {
        type:              type,
        token:             token,
        text:              to_s(:base),
        starts_at:         ts,
        length:            full_length,
        level:             level,
        set_level:         set_level,
        conditional_level: conditional_level,
        options:           options,
        quantifier:        quantified? ? quantifier.to_h : nil,
      }
    end
    alias :attributes :to_h

    # Recalculates the nesting_level for this node and children, which reflects
    # how deep a node is in the tree. Do this at the end of parsing to account
    # for tree rewrites.
    # This must be safe against overflows and performant - check the benchmarks.
    def recursively_update_nesting_levels(base = nesting_level)
      queue = [base, self]

      until queue.empty?
        exp = queue.pop
        exp_lvl = queue.pop
        exp.nesting_level = exp_lvl
        exp.quantifier.nesting_level = exp_lvl if exp.quantifier
        exp.terminal? || exp.expressions.each do |subexp|
          queue.push(exp_lvl + 1, subexp)
        end
      end
    end
  end
end
