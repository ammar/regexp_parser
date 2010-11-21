require File.expand_path('../1.8.7', __FILE__)

module Regexp::Syntax

  module Ruby
    class V18 < Regexp::Syntax::Ruby::V187
      def initialize
        super
      end
    end
  end

end
