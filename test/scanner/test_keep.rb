require File.expand_path("../../helpers", __FILE__)

class ScannerKeep < Test::Unit::TestCase

  def test_scan_keep_token
    tokens = RS.scan(/ab\Kcd/)
    result = tokens.at(1)

    assert_equal :keep, result[0]
    assert_equal :mark, result[1]
    assert_equal '\\K', result[2]
    assert_equal 2,     result[3]
    assert_equal 4,     result[4]
  end

  def test_scan_keep_nested
    tokens = RS.scan(/(a\Kb)|(c\\\Kd)ef/)

    first  = tokens.at(2)
    second = tokens.at(9)

    assert_equal :keep, first[0]
    assert_equal :mark, first[1]
    assert_equal '\\K', first[2]
    assert_equal 2,     first[3]
    assert_equal 4,     first[4]

    assert_equal :keep, second[0]
    assert_equal :mark, second[1]
    assert_equal '\\K', second[2]
    assert_equal 11,    second[3]
    assert_equal 13,    second[4]
  end

end
