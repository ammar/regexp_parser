class Regexp::Syntax::V1_9_1 < Regexp::Syntax::V1_8_6
  implements :assertion,     Assertion::Lookbehind
  implements :backref,       Backref::V1_9_1 + SubexpressionCall::All
  implements :escape,        Escape::Unicode + Escape::Hex + Escape::Octal
  implements :posixclass,    PosixClass::Extensions
  implements :nonposixclass, PosixClass::All
  implements :property,      Property::V1_9_0
  implements :nonproperty,   Property::V1_9_0
  implements :quantifier,    Quantifier::Possessive + Quantifier::IntervalPossessive
  implements :type,          CharacterType::Hex
end
