module Regexp::Expression
  class Base
    module ClassMethods; end # filled in ./methods/*.rb

    extend ClassMethods

    attr_accessor :type, :token, :text, :ts, :te,
                  :level, :set_level, :conditional_level,
                  :options, :parent,
                  :custom_to_s_handling, :pre_quantifier_decorations

    attr_reader   :nesting_level, :quantifier


    def initialize(token, options = {})
      self.type              = token.type
      self.token             = token.token
      self.text              = token.text
      self.ts                = token.ts
      self.te                = token.te
      self.level             = token.level
      self.set_level         = token.set_level
      self.conditional_level = token.conditional_level
      self.nesting_level     = 0
      self.options           = options || {}
    end

    def initialize_copy(orig)
      self.text       = orig.text.dup         if orig.text
      self.options    = orig.options.dup      if orig.options
      self.quantifier = orig.quantifier.clone if orig.quantifier
      super
    end

    def starts_at
      ts
    end

    def ends_at(include_quantifier = true)
      ts + (include_quantifier ? full_length : base_length)
    end

    def base_length
      to_s(:base).length
    end

    def full_length
      to_s(:original).length
    end

    # #to_s reproduces the original source, as an unparser would.
    #
    # It takes an optional format argument.
    #
    # Example:
    #
    # lit = Regexp::Parser.parse(/a +/x)[0]
    #
    # lit.to_s            # => 'a+'  # default; with quantifier
    # lit.to_s(:full)     # => 'a+'  # default; with quantifier
    # lit.to_s(:base)     # => 'a'   # without quantifier
    # lit.to_s(:original) # => 'a +' # with quantifier AND intermittent decorations
    #
    def to_s(format = :full)
      base = parts.each_with_object(''.dup) do |part, buff|
        if part.instance_of?(String)
          buff << part
        elsif !part.custom_to_s_handling
          buff << part.to_s(:original)
        end
      end
      "#{base}#{pre_quantifier_decoration(format)}#{quantifier_affix(format)}"
    end
    alias :to_str :to_s

    def pre_quantifier_decoration(expression_format = :original)
      pre_quantifier_decorations.to_a.join if expression_format == :original
    end

    def quantifier_affix(expression_format = :full)
      quantifier.to_s if quantified? && expression_format != :base
    end

    def offset
      [starts_at, full_length]
    end

    def coded_offset
      '@%d+%d' % offset
    end

    def nesting_level=(lvl)
      @nesting_level = lvl
      quantifier&.nesting_level = lvl
      terminal? || each { |subexp| subexp.nesting_level = lvl + 1 }
    end

    def quantifier=(qtf)
      @quantifier = qtf
      @repetitions = nil # clear memoized value
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

    # Note: `#repetitions` which has a more uniform interface.
    def quantity
      return [nil,nil] unless quantified?
      [quantifier.min, quantifier.max]
    end

    def repetitions
      @repetitions ||=
        if quantified?
          min = quantifier.min
          max = quantifier.max < 0 ? Float::INFINITY : quantifier.max
          range = min..max
          # fix Range#minmax on old Rubies - https://bugs.ruby-lang.org/issues/15807
          if RUBY_VERSION.to_f < 2.7
            range.define_singleton_method(:minmax) { [min, max] }
          end
          range
        else
          1..1
        end
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
  end
end
