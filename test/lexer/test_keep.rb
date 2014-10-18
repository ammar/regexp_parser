require File.expand_path("../../helpers", __FILE__)

class LexerKeep < Test::Unit::TestCase

  def test_lex_keep_token
    regexp = /ab\Kcd/
    tokens = RL.lex(regexp)

    assert_equal( :keep, tokens[1][0] )
    assert_equal( :mark, tokens[1][1] )
  end

  def test_lex_keep_nested
    regexp = /(a\Kb)|(c\\\Kd)ef/
    tokens = RL.lex(regexp)

    assert_equal( :keep, tokens[2][0] )
    assert_equal( :mark, tokens[2][1] )

    assert_equal( :keep, tokens[9][0] )
    assert_equal( :mark, tokens[9][1] )
  end

end
