require File.expand_path('../2.2.1', __FILE__)

module Regexp::Syntax
  module Ruby

    class V222 < Regexp::Syntax::Ruby::V221
      def initialize
        super
      end
    end

  end
end
