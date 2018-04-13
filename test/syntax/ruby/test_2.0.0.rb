require File.expand_path("../../../helpers", __FILE__)

class TestSyntaxRuby_V200 < Test::Unit::TestCase
  include Regexp::Syntax::Token

  def setup
    @syntax = Regexp::Syntax.new 'ruby/2.0.0'
  end

  tests = {
    :implements => {
      :property => [
        UnicodeProperty::Age_V200
      ].flatten,

      :nonproperty => [
        UnicodeProperty::Age_V200
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
        define_method "test_syntax_ruby_v200_#{method}_#{type}_#{token}" do
          assert_equal expected, @syntax.implements?(type, token)
        end
      end
    end
  end
end
