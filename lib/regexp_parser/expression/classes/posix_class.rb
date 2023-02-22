module Regexp::Expression
  class PosixClass < Regexp::Expression::Base
    def negative?
      type == :nonposixclass
    end

    def name
      text[/\w+/]
    end
  end
end
