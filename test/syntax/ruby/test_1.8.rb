require File.expand_path("../../../helpers", __FILE__)

class TestSyntaxRuby_V18 < Test::Unit::TestCase
  include Regexp::Syntax::Token

  def setup
    @syntax = Regexp::Syntax.new 'ruby/1.8'
  end

  tests = {
    :implements => {
      :assertion    => [Assertion::Lookahead].flatten,
      :backref      => [:number],
      :escape       => [Escape::All].flatten,
      :group        => [Group::All].flatten,
      :quantifier   => [
          Quantifier::Greedy + Quantifier::Reluctant +
          Quantifier::Interval + Quantifier::IntervalReluctant
      ].flatten,
    },

    :excludes => {
      :assertion    => [Assertion::Lookbehind].flatten,

      :backref => [
        Backreference::All + SubexpressionCall::All
      ].flatten,

      :quantifier => [
        Quantifier::Possessive
      ].flatten,

      :subset => nil
    },
  }

  tests.each do |method, types|
    expected = method == :excludes ? false : true

    types.each do |type, tokens|
      if tokens.nil? or tokens.empty?
        define_method "test_syntax_ruby_v18_#{method}_#{type}" do
          assert_equal expected, @syntax.implements?(type, nil)
        end
      else
        tokens.each do |token|
          define_method "test_syntax_ruby_v18_#{method}_#{type}_#{token}" do
            assert_equal expected, @syntax.implements?(type, token)
          end
        end
      end
    end
  end

end
