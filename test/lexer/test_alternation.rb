require File.expand_path("../../helpers", __FILE__)

class TestRegexpLexerAlternation < Test::Unit::TestCase

  def test_lexer_alternation
    tokens = RL.scan('ab??|cd*+|ef+')

    [2,5].each do |i|
      assert_equal( :meta,        tokens[i].type )
      assert_equal( :alternation, tokens[i].token )
      assert_equal( '|',          tokens[i].text )
    end
  end

end
