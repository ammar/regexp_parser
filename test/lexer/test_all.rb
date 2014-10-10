require File.expand_path("../../helpers", __FILE__)

%w{
  conditionals literals nesting refcalls
}.each do|tc|
  require File.expand_path("../test_#{tc}", __FILE__)
end

class TestRegexpLexer < Test::Unit::TestCase

  def test_lexer_returns_an_array
    assert_instance_of( Array, RL.scan('abc'))
  end

  def test_lexer_returns_tokens
    tokens = RL.scan('^abc+[^one]{2,3}\b\d\\\C-C$')
    assert( tokens.all?{|token| token.kind_of?(Regexp::Token)},
          "Not all array members are tokens")

    assert( tokens.all?{|token| token.to_a.length == 8},
          "Not all tokens have a length of 8")
  end

  def test_lexer_token_count
    tokens = RL.scan(/^(one|two){2,3}([^d\]efm-qz\,\-]*)(ghi)+$/i)
    assert_equal( 26, tokens.length )
  end

end
