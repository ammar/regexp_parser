module Regexp::Syntax

  module Ruby
    class V193 < Regexp::Syntax::Ruby::V191
      include Regexp::Syntax::Token

      def initialize
        super

        # these were added with update of Oniguruma to Unicode 6.0
        implements :property,    UnicodeProperty::V193
        implements :nonproperty, UnicodeProperty::V193
      end
    end
  end

end
