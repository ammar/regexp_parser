require File.expand_path("../../../helpers", __FILE__)

class TestSyntaxRuby_V18 < Test::Unit::TestCase
  include Regexp::Syntax::Token

  def setup
    @name   = 'ruby/1.8'
    @syntax = Regexp::Syntax.new @name
  end

  tests = {
    :implements => {
      :escape => [
        Escape::Backreference + Escape::ASCII + Escape::Meta
      ].flatten,

      :group => [
        Group::All
      ].flatten,

      :assertion => [
        Group::Assertion::All
      ].flatten,

      :quantifier => [
        Quantifier::Greedy
      ].flatten,
    },

    :excludes => {
      :quantifier => [
        Quantifier::Reluctant + Quantifier::Possessive
      ].flatten,
    },
  }

  tests.each do |method, types|
    types.each do |type, tokens|
      tokens.each do |token|
        define_method "test_syntax_ruby_v18_#{method}_#{type}_#{token}" do
          assert_equal(
            method == :excludes ? false : true,
            @syntax.implements?(type, token)
          )
        end
      end
    end
  end

end
