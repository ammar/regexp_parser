require "test/unit"

require File.expand_path("../../lib/regexp_parser", __FILE__)
require File.expand_path("../../lib/regexp_parser/lexer", __FILE__)

RL = Regexp::Lexer

class TestRegexpLexer < Test::Unit::TestCase

  def test_lexer_returns_an_array
    assert_instance_of( Array, RL.lex('abc'))
  end

  def test_lexer_returns_tokens
    tokens = RL.lex('^abc+[^one]{2,3}\b\d\\\C-C$')
    assert( tokens.all?{|token| token.kind_of?(Regexp::Token)},
          "Not all array members are tokens")
  end

  # too much going on here, it's just for development
  def test_lexer_token_count
    tokens = RL.lex(/^(one|two){2,3}([^d\]efm-qz\,\-]*)(ghi)+$/i)
    assert_equal( 28, tokens.length )
  end
end
