module Regexp::Expression
  module Shared
    def self.included(mod)
      mod.class_eval do
        attr_accessor :type, :token, :text, :ts, :te,
                      :level, :set_level, :conditional_level,
                      :options, :quantifier

        attr_reader   :nesting_level
      end
    end

    def init_from_token_and_options(token, options = {})
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

    def terminator_text
      nil
    end

    def nesting_level=(lvl = 0)
      @nesting_level = lvl
      quantifier && quantifier.nesting_level = lvl
      terminal? || each { |subexp| subexp.nesting_level = lvl + 1 }
    end
  end
end
