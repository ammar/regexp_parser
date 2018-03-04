require File.expand_path('../2.2', __FILE__)

module Regexp::Syntax
  module Ruby

    class V230 < Regexp::Syntax::Ruby::V22
      def initialize
        super

        implements :property,    UnicodeProperty::V230
        implements :nonproperty, UnicodeProperty::V230
      end
    end

  end
end
