require File.expand_path('../1.8', __FILE__)

module Regexp::Syntax

  module Ruby
    class V191 < Regexp::Syntax::Ruby::V18
      include Regexp::Syntax::Token

      def initialize
        super

        implements :quantifier, 
          Quantifier::Reluctant + Quantifier::Possessive

        implements :set, 
          CharacterSet::POSIX::Extensions 
      end
    end
  end

end
