require File.expand_path('../1.9', __FILE__)

module Regexp::Syntax
  module Ruby

    # use the last 1.9 release as the base
    class V200 < Regexp::Syntax::Ruby::V19
      def initialize
        super

        implements :conditional, Conditional::All
      end
    end

  end
end
