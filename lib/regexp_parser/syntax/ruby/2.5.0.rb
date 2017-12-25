require File.expand_path('../2.4', __FILE__)

module Regexp::Syntax
  module Ruby

    class V250 < Regexp::Syntax::Ruby::V24
      def initialize
        super
      end
    end

  end
end
