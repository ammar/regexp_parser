require File.expand_path('../2.3', __FILE__)

module Regexp::Syntax
  module Ruby

    class V240 < Regexp::Syntax::Ruby::V23
      def initialize
        super

        implements :property,    UnicodeProperty::V240
        implements :nonproperty, UnicodeProperty::V240
      end
    end

  end
end
