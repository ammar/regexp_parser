require File.expand_path('../2.1.8', __FILE__)

module Regexp::Syntax
  module Ruby

    class V219 < Regexp::Syntax::Ruby::V218
      def initialize
        super
      end
    end

  end
end
