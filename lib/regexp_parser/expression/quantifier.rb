module Regexp::Expression
  class Quantifier
    MODES = [:greedy, :possessive, :reluctant]

    attr_reader :token, :text, :min, :max, :mode

    def initialize(token, text, min, max, mode)
      @token = token
      @text  = text
      @mode  = mode
      @min   = min
      @max   = max
    end

    def initialize_clone(other)
      other.instance_variable_set(:@text, text.dup)
      super
    end

    def to_s
      text.dup
    end
    alias :to_str :to_s

    def to_h
      {
        token: token,
        text:  text,
        mode:  mode,
        min:   min,
        max:   max,
      }
    end

    MODES.each { |m| define_method("#{m}?") { mode.equal?(m) } }
  end
end
