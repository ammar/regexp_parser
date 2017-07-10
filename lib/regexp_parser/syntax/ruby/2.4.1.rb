require File.expand_path('../2.4.0', __FILE__)

module Regexp::Syntax
  module Ruby

    class V241 < Regexp::Syntax::Ruby::V240
      def initialize
        super

        implements :group, Group::Absence
      end
    end

  end
end
