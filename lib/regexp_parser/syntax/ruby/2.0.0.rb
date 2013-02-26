require File.expand_path('../1.9.3', __FILE__)

module Regexp::Syntax
  module Ruby

    # use the last 1.9 release as the base
    class V20 < Regexp::Syntax::Ruby::V193
      def initialize
        super

        #implements :escape, CharacterType::Hex
      end
    end

  end
end
