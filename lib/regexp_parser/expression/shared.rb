module Regexp::Expression
  module Shared
    def self.included(mod)
      mod.class_eval do
        attr_accessor :type, :token, :text, :ts,
                      :level, :set_level, :conditional_level, :nesting_level,
                      :options, :quantifier
      end
    end

    def init_from_token_and_options(token, options = {})
      self.type              = token.type
      self.token             = token.token
      self.text              = token.text
      self.ts                = token.ts
      self.level             = token.level
      self.set_level         = token.set_level
      self.conditional_level = token.conditional_level
      self.nesting_level     = 0
      self.options           = options || {}
    end
    private :init_from_token_and_options

    def initialize_copy(orig)
      self.text       = orig.text.dup         if orig.text
      self.options    = orig.options.dup      if orig.options
      self.quantifier = orig.quantifier.clone if orig.quantifier
      super
    end

    def starts_at
      ts
    end

    def base_length
      to_s(:base).length
    end

    def full_length
      to_s.length
    end

    def offset
      [starts_at, full_length]
    end

    def coded_offset
      '@%d+%d' % offset
    end

    def terminal?
      !respond_to?(:expressions)
    end
  end
end