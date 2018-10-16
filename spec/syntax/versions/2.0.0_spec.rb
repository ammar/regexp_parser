require 'spec_helper'

RSpec.describe(Regexp::Syntax::V2_0_0) do
  let(:syntax) { Regexp::Syntax.new('ruby/2.0.0') }

  tests = {
    implements: {
      property: T::UnicodeProperty::Age_V2_0_0,
      nonproperty: T::UnicodeProperty::Age_V2_0_0
    },
    excludes: {
      property: [:newline],
      nonproperty: [:newline]
    }
  }

  tests.each do |method, types|
    expected = method != :excludes

    types.each do |type, tokens|
      tokens.each do |token|
        specify("syntax_ruby_V2_0_0_#{method}_#{type}_#{token}") do
          expect(syntax.implements?(type, token)).to eq expected
        end
      end
    end
  end
end
