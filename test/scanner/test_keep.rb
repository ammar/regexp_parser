require File.expand_path("../../helpers", __FILE__)

class ScannerKeep < Test::Unit::TestCase

  def test_scan_keep_token
    regexp = /ab\Kcd/
    tokens = RS.scan(regexp)

    assert_equal( :keep, tokens[1][0] )
    assert_equal( :mark, tokens[1][1] )
    assert_equal( '\\K', tokens[1][2] )
    assert_equal( 2,     tokens[1][3] )
    assert_equal( 4,     tokens[1][4] )
  end

  def test_scan_keep_nested
    regexp = /(a\Kb)|(c\\\Kd)ef/
    tokens = RS.scan(regexp)

    assert_equal( :keep, tokens[2][0] )
    assert_equal( :mark, tokens[2][1] )
    assert_equal( '\\K', tokens[2][2] )
    assert_equal( 2,     tokens[2][3] )
    assert_equal( 4,     tokens[2][4] )

    assert_equal( :keep, tokens[9][0] )
    assert_equal( :mark, tokens[9][1] )
    assert_equal( '\\K', tokens[9][2] )
    assert_equal( 11,    tokens[9][3] )
    assert_equal( 13,    tokens[9][4] )
  end

end
