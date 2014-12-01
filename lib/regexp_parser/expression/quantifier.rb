module Regexp::Expression

  class Quantifier
    attr_reader   :token, :text, :min, :max, :mode

    def initialize(token, text, min, max, mode)
      @token = token
      @text  = text
      @mode  = mode
      @min   = min
      @max   = max
    end

    def clone
      copy = self.dup
      copy.instance_variable_set(:@text, @text.dup)
      copy
    end

    def to_s
      @text.dup
    end
    alias :to_str :to_s

    def to_h
      {
        :token => token,
        :text  => text,
        :mode  => mode,
        :min   =>  min,
        :max   =>  max
      }
    end
  end

end
