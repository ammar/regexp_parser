# frozen_string_literal: true

module Regexp::Expression
  module Shared
    module ClassMethods; end # filled in ./methods/*.rb

    def self.included(mod)
      mod.class_eval do
        extend Shared::ClassMethods

        attr_accessor :type, :token, :text, :ts, :te,
                      :level, :set_level, :conditional_level, :nesting_level,
                      :options, :parent, :quantifier
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
      super
      self.text       = orig.text.dup         if orig.text
      self.options    = orig.options.dup      if orig.options
      self.quantifier = orig.quantifier.clone if orig.quantifier
      self.parent     = nil # updated by Subexpression#initialize_copy
      if orig.respond_to?(:option_changes) && orig.option_changes
        self.option_changes = orig.option_changes.dup
      end
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

    def offset
      [starts_at, full_length]
    end

    def coded_offset
      '@%d+%d' % offset
    end
  end
end
