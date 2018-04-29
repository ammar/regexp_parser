module Regexp::Expression
  class CharacterClass < Regexp::Expression::Base
    def negative?
      type == :noncharclass
    end

    def name
      token.to_s
    end
  end
end
