require File.expand_path("../../../helpers", __FILE__)

class TestSyntaxV1_8 < Test::Unit::TestCase
  include Regexp::Syntax::Token

  def setup
    @syntax = Regexp::Syntax.new 'ruby/1.8'
  end

  tests = {
    implements: {
      assertion:    [Assertion::Lookahead].flatten,
      backref:      [:number],
      escape:       [Escape::All].flatten,
      group:        [Group::V1_8_6].flatten,
      quantifier:   [
          Quantifier::Greedy + Quantifier::Reluctant +
          Quantifier::Interval + Quantifier::IntervalReluctant
      ].flatten,
    },

    excludes: {
      assertion: [Assertion::Lookbehind].flatten,

      backref: [
        Backreference::All - [:number] + SubexpressionCall::All
      ].flatten,

      quantifier: [
        Quantifier::Possessive
      ].flatten
    },
  }

  tests.each do |method, types|
    expected = method == :excludes ? false : true

    types.each do |type, tokens|
      if tokens.nil? or tokens.empty?
        define_method "test_syntax_V1_8_#{method}_#{type}" do
          assert_equal expected, @syntax.implements?(type, nil)
        end
      else
        tokens.each do |token|
          define_method "test_syntax_V1_8_#{method}_#{type}_#{token}" do
            assert_equal expected, @syntax.implements?(type, token)
          end
        end
      end
    end
  end

end
