module Regexp::Syntax
  module Ruby

    class V250 < Regexp::Syntax::Ruby::V24
      def initialize
        super

        implements :property,    UnicodeProperty::V250
        implements :nonproperty, UnicodeProperty::V250
      end
    end

  end
end
