require File.expand_path('../1.9.2', __FILE__)

module Regexp::Syntax

  module Ruby
    class V193 < Regexp::Syntax::Ruby::V192
      include Regexp::Syntax::Token

      def initialize
        super

        # these were added with update of Oniguruma to Unicode 6.0
        implements :property,
          [:script_mandaic, :script_batak, :script_brahmi]

        implements :nonproperty,
          [:script_mandaic, :script_batak, :script_brahmi]
      end
    end
  end

end
