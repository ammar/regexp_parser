require File.expand_path("../../helpers", __FILE__)

%w{
  literals nesting refcalls
}.each do|tc|
  require File.expand_path("../test_#{tc}", __FILE__)
end

if RUBY_VERSION >= '2.0.0'
  %w{conditionals keep}.each do|tc|
    require File.expand_path("../test_#{tc}", __FILE__)
  end
end

class TestRegexpLexer < Test::Unit::TestCase

  def test_lexer_returns_an_array
    assert_instance_of Array, RL.lex('abc')
  end

  def test_lexer_returns_tokens
    tokens = RL.lex('^abc+[^one]{2,3}\b\d\\\C-C$')

    assert tokens.all?{ |token| token.kind_of?(Regexp::Token) },
          "Not all array members are tokens"

    assert tokens.all?{ |token| token.to_a.length == 8 },
          "Not all tokens have a length of 8"
  end

  def test_lexer_token_count
    tokens = RL.lex(/^(one|two){2,3}([^d\]efm-qz\,\-]*)(ghi)+$/i)

    assert_equal 28, tokens.length
  end

  def test_lexer_scan_alias
    assert_equal RL.lex(/a|b|c/), RL.scan(/a|b|c/)
  end

end
