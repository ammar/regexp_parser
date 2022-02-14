require 'spec_helper'

RSpec.describe(Regexp::Syntax::V1_9_1) do
  include_examples 'syntax',
  implements: {
    escape: T::Escape::Hex + T::Escape::Octal + T::Escape::Unicode,
    type: T::CharacterType::Hex,
    quantifier: T::Quantifier::Greedy + T::Quantifier::Reluctant + T::Quantifier::Possessive
  }
end
