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

    def quantify(*args)
      self.quantifier = Quantifier.new(*args)
    end

    def unquantified_clone
      clone.tap { |exp| exp.quantifier = nil }
    end

    # Deprecated. Prefer `#repetitions` which has a more uniform interface.
    def quantity
      return [nil, nil] unless quantified?

      [quantifier.min, quantifier.max]
    end

    def repetitions
      return 1..1 unless quantified?

      min = quantifier.min
      max = quantifier.max < 0 ? Float::INFINITY : quantifier.max
      min..max
    end

    def greedy?
      quantified? and quantifier.greedy?
    end

    def reluctant?
      quantified? and quantifier.reluctant?
    end
    alias :lazy? :reluctant?

    def possessive?
      quantified? and quantifier.possessive?
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

    # Assigns referenced expressions to referring expressions, e.g. if there is
    # an instance of Backreference::Number, its #referenced_expression is set to
    # the instance of Group::Capture that it refers to via its number.
    def assign_referenced_expressions
      # find all referenceable and referring expressions
      targets = {}
      targets[0] = [self] if instance_of?(Root)
      referrers = []
      each_expression do |exp|
        if exp.referential?
          referrers << exp
        elsif exp.is_a?(Group::Capture)
          (targets[exp.identifier] ||= []) << exp
        end
      end
      # assign referenced expressions to referring expressions
      # (in a second iteration because there might be forward references)
      referrers.each do |exp|
        exp.referenced_expressions = targets[exp.reference] || raise(
          Regexp::Parser::ParserError,
          "Invalid reference #{exp.reference} at pos #{exp.ts}"
        )
      end
    end
  end
end
