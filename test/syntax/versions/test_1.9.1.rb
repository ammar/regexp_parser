require File.expand_path("../../../helpers", __FILE__)

class TestSyntaxV1_9_1 < Test::Unit::TestCase
  include Regexp::Syntax::Token

  def setup
    @syntax = Regexp::Syntax.new 'ruby/1.9.1'
  end

  tests = {
    implements: {
      escape: [
        Escape::Hex + Escape::Octal + Escape::Unicode
      ].flatten,

      type: [
        CharacterType::Hex
      ].flatten,

      quantifier: [
        Quantifier::Greedy + Quantifier::Reluctant + Quantifier::Possessive
      ].flatten,
    },
  }

  tests.each do |method, types|
    types.each do |type, tokens|
      tokens.each do |token|
        define_method "test_syntax_V1_9_1_#{method}_#{type}_#{token}" do
          assert_equal true, @syntax.implements?(type, token)
        end
      end
    end
  end

end
