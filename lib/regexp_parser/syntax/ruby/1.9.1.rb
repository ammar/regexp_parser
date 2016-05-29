require File.expand_path('../1.8', __FILE__)

module Regexp::Syntax

  module Ruby
    class V191 < Regexp::Syntax::Ruby::V18
      include Regexp::Syntax::Token

      def initialize
        super

        implements :assertion, Assertion::Lookbehind +
          SubexpressionCall::All

        implements :backref, Backreference::All +
          SubexpressionCall::All

        implements :escape, Escape::Unicode + Escape::Hex

        implements :type, CharacterType::Hex

        implements :property,
          UnicodeProperty::V190

        implements :nonproperty,
          UnicodeProperty::V190

        implements :quantifier,
          Quantifier::Possessive + Quantifier::IntervalPossessive

        implements :set,
          CharacterSet::POSIX::StandardNegative +
          CharacterSet::POSIX::Extensions +
          CharacterSet::POSIX::ExtensionsNegative +
          UnicodeProperty::V190

        implements :subset, CharacterSet::OpenClose +
          CharacterSet::Extended + CharacterSet::Types +
          CharacterSet::POSIX::Standard
      end

    end
  end

end
