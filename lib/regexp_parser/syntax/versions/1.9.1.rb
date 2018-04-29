module Regexp::Syntax
  class V1_9_1 < Regexp::Syntax::V1_8_6
    def initialize
      super

      implements :assertion, Assertion::Lookbehind +
        SubexpressionCall::All

      implements :backref, Backreference::All +
        SubexpressionCall::All

      implements :escape, Escape::Unicode + Escape::Hex + Escape::Octal

      implements :type, CharacterType::Hex

      implements :property,
        UnicodeProperty::V1_9_0

      implements :nonproperty,
        UnicodeProperty::V1_9_0

      implements :quantifier,
        Quantifier::Possessive + Quantifier::IntervalPossessive

      implements :set,
        CharacterSet::POSIX::StandardNegative +
        CharacterSet::POSIX::Extensions +
        CharacterSet::POSIX::ExtensionsNegative +
        UnicodeProperty::V1_9_0

      implements :subset, CharacterSet::OpenClose +
        CharacterSet::Extended + CharacterSet::Types +
        CharacterSet::POSIX::Standard
    end
  end
end
