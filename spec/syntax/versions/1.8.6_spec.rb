require 'spec_helper'

RSpec.describe(Regexp::Syntax::V1_8_6) do
  let(:syntax) { Regexp::Syntax.new('ruby/1.8.6') }

  tests = {
    implements: {
      assertion: T::Assertion::Lookahead,
      backref: [:number],
      escape: T::Escape::Basic + T::Escape::ASCII + T::Escape::Meta + T::Escape::Control,
      group: T::Group::V1_8_6,
      quantifier: T::Quantifier::Greedy + T::Quantifier::Reluctant + T::Quantifier::Interval + T::Quantifier::IntervalReluctant
    },
    excludes: {
      assertion: T::Assertion::Lookbehind,
      backref: T::Backreference::All - [:number] + T::SubexpressionCall::All,
      quantifier: T::Quantifier::Possessive
    }
  }

  tests.each do |method, types|
    expected = method != :excludes

    types.each do |type, tokens|
      if tokens.nil? || tokens.empty?
        specify("syntax_V1_8_#{method}_#{type}") do
          expect(syntax.implements?(type, nil)).to eq expected
        end
      else
        tokens.each do |token|
          specify("syntax_V1_8_#{method}_#{type}_#{token}") do
            expect(syntax.implements?(type, token)).to eq expected
          end
        end
      end
    end
  end
end
