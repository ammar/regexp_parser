require File.expand_path("../../../helpers", __FILE__)

class TestSyntaxV2_2_0 < Test::Unit::TestCase
  include Regexp::Syntax::Token

  def setup
    @syntax = Regexp::Syntax.new 'ruby/2.2.0'
  end

  tests = {
    implements: {
      property: [
        UnicodeProperty::Script_V2_2_0 + UnicodeProperty::Age_V2_2_0
      ].flatten,

      nonproperty: [
        UnicodeProperty::Script_V2_2_0 + UnicodeProperty::Age_V2_2_0
      ].flatten,
    },
  }

  tests.each do |method, types|
    types.each do |type, tokens|
      tokens.each do |token|
        define_method "test_syntax_V2_2_0_#{method}_#{type}_#{token}" do
          assert_equal true, @syntax.implements?(type, token)
        end
      end
    end
  end

end
