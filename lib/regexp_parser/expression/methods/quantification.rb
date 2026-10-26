# frozen_string_literal: true

module Regexp::Expression
  class Base
    def quantify(*args)
      self.quantifier = Quantifier.new(*args)
    end

    def unquantified_clone
      dup.tap { |exp| exp.quantifier = nil }
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
  end
end
