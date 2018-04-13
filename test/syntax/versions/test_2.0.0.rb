require File.expand_path("../../../helpers", __FILE__)

class TestSyntaxV2_0_0 < Test::Unit::TestCase
  include Regexp::Syntax::Token

  def setup
    @syntax = Regexp::Syntax.new 'ruby/2.0.0'
  end

  tests = {
    implements: {
      property: [
        UnicodeProperty::Age_V2_0_0
      ].flatten,

      nonproperty: [
        UnicodeProperty::Age_V2_0_0
      ].flatten,
    },
    excludes: {
      property:    [:newline],
      nonproperty: [:newline],
    }
  }

  tests.each do |method, types|
    expected = method == :excludes ? false : true

    types.each do |type, tokens|
      tokens.each do |token|
        define_method "test_syntax_ruby_V2_0_0_#{method}_#{type}_#{token}" do
          assert_equal expected, @syntax.implements?(type, token)
        end
      end
    end
  end
end
