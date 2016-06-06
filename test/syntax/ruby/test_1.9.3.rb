require File.expand_path("../../../helpers", __FILE__)

class TestSyntaxRuby_V193 < Test::Unit::TestCase
  include Regexp::Syntax::Token

  def setup
    @syntax = Regexp::Syntax.new 'ruby/1.9.3'
  end

  tests = {
    :implements => {
      :property => [
        UnicodeProperty::Script_6_0 + UnicodeProperty::Age_V193
      ].flatten,

      :nonproperty => [
        UnicodeProperty::Script_6_0 + UnicodeProperty::Age_V193
      ].flatten,
    },
  }

  tests.each do |method, types|
    types.each do |type, tokens|
      tokens.each do |token|
        define_method "test_syntax_ruby_v193_#{method}_#{type}_#{token}" do
          assert_equal true, @syntax.implements?(type, token)
        end
      end
    end
  end

end
