require 'spec_helper'

RSpec.describe(Regexp::Syntax::V2_2_0) do
  let(:syntax) { Regexp::Syntax.new('ruby/2.2.0') }

  tests = {
    implements: {
      property: T::UnicodeProperty::Script_V2_2_0 + T::UnicodeProperty::Age_V2_2_0,
      nonproperty: T::UnicodeProperty::Script_V2_2_0 + T::UnicodeProperty::Age_V2_2_0
    }
  }

  tests.each do |method, types|
    types.each do |type, tokens|
      tokens.each do |token|
        specify("syntax_V2_2_0_#{method}_#{type}_#{token}") do
          expect(syntax.implements?(type, token)).to be true
        end
      end
    end
  end
end
