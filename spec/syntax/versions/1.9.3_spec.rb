require 'spec_helper'

RSpec.describe(Regexp::Syntax::V1_9_3) do
  let(:syntax) { Regexp::Syntax.new('ruby/1.9.3') }

  tests = {
    implements: {
      property: T::UnicodeProperty::Script_V1_9_3 + T::UnicodeProperty::Age_V1_9_3,
      nonproperty: T::UnicodeProperty::Script_V1_9_3 + T::UnicodeProperty::Age_V1_9_3
    }
  }

  tests.each do |method, types|
    types.each do |type, tokens|
      tokens.each do |token|
        specify("syntax_V1_9_3_#{method}_#{type}_#{token}") do
          expect(syntax.implements?(type, token)).to be true
        end
      end
    end
  end
end
