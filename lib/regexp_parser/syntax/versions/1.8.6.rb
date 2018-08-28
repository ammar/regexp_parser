module Regexp::Syntax
  class V1_8_6 < Regexp::Syntax::Base
    def initialize
      super

      implements :anchor, Anchor::All
      implements :assertion, Assertion::Lookahead
      implements :backref, [:number]
      implements :posixclass, PosixClass::Standard
      implements :escape,
        Escape::Basic + Escape::Backreference +
        Escape::ASCII + Escape::Meta + Escape::Control

      implements :group, Group::All

      implements :meta, Meta::Extended

      implements :quantifier,
        Quantifier::Greedy + Quantifier::Reluctant +
        Quantifier::Interval + Quantifier::IntervalReluctant

      implements :set, CharacterSet::OpenClose + CharacterSet::Extended

      implements :type,
        CharacterType::Extended
    end
  end
end
