require File.expand_path('../2.1', __FILE__)

module Regexp::Syntax
  module Ruby

    class V220 < Regexp::Syntax::Ruby::V21
      def initialize
        super

        implements :property,    UnicodeProperty::V220
        implements :nonproperty, UnicodeProperty::V220
      end
    end

  end
end
