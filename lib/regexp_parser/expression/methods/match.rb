module Regexp::Expression
  class Base
    def match?(string)
      Regexp.new(to_s).match?(string)
    end
    alias :matches? :match?

    def match(string, offset = 0)
      Regexp.new(to_s).match(string, offset)
    end
    alias :=~ :match
  end
end
