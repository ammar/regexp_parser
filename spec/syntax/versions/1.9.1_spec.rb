require 'spec_helper'

RSpec.describe(Regexp::Syntax::V1_9_1) do
  let(:syntax) { Regexp::Syntax.new('ruby/1.9.1') }

  tests = {
    implements: {
      escape: T::Escape::Hex + T::Escape::Octal + T::Escape::Unicode,
      type: T::CharacterType::Hex,
      quantifier: T::Quantifier::Greedy + T::Quantifier::Reluctant + T::Quantifier::Possessive
    }
  }

  tests.each do |method, types|
    types.each do |type, tokens|
      tokens.each do |token|
        specify("syntax_V1_9_1_#{method}_#{type}_#{token}") do
          expect(syntax.implements?(type, token)).to be true
        end
      end
    end
  end
end
