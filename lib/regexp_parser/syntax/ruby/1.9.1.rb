require File.expand_path('../1.8', __FILE__)

module Regexp::Syntax

  module Ruby
    class V191 < Regexp::Syntax::Ruby::V18
      include Regexp::Syntax::Token

      def initialize
        super

        implements :backref, Group::Backreference::All +
          Group::SubexpressionCall::All

        implements :escape, CharacterType::Hex

        implements :quantifier, 
          Quantifier::Reluctant + Quantifier::Possessive

        implements :set, 
          CharacterSet::POSIX::StandardNegative +
          CharacterSet::POSIX::Extensions +
          CharacterSet::POSIX::ExtensionsNegative

        implements :subset, CharacterSet::OpenClose +
          CharacterSet::Extended + CharacterSet::Types +
          CharacterSet::POSIX::Standard 
      end

    end
  end

end