require File.expand_path('../../../helpers', __FILE__)

class ParserSetRangs < Test::Unit::TestCase
  # TODO: enable commented assertions when escapes are parsed correctly

  def test_parse_set_range
    root  = RP.parse('[a-z]', 'ruby/1.9')
    set   = root[0]
    range = set[0]

    assert_equal 1, set.count
    assert_equal CharacterSet::Range, range.class
    assert_equal 2, range.count
    assert_equal 'a', range.first.to_s
    assert_equal Literal, range.first.class
    assert_equal 'z', range.last.to_s
    assert_equal Literal, range.last.class
    assert_equal true, set.matches?('m')
  end

  def test_parse_set_range_hex
    root  = RP.parse('[\x00-\x99]', 'ruby/1.9')
    set   = root[0]
    range = set[0]

    assert_equal 1, set.count
    assert_equal CharacterSet::Range, range.class
    assert_equal 2, range.count
    assert_equal '\x00', range.first.to_s
    # assert_equal EscapeSequence::Hex, range.first.class
    assert_equal '\x99', range.last.to_s
    # assert_equal EscapeSequence::Hex, range.last.class
    assert_equal true, set.matches?('\x50')
  end

  def test_parse_set_range_unicode
    root  = RP.parse('[\u{40 42}-\u1234]', 'ruby/1.9')
    set   = root[0]
    range = set[0]

    assert_equal 1, set.count
    assert_equal CharacterSet::Range, range.class
    assert_equal 2, range.count
    assert_equal '\u{40 42}', range.first.to_s
    # assert_equal EscapeSequence::CodepointList, range.first.class
    assert_equal '\u1234', range.last.to_s
    # assert_equal EscapeSequence::CodepointSingle, range.last.class
    assert_equal true, set.matches?('\u600')
  end

  def test_parse_set_range_edge_case_leading_dash
    root  = RP.parse('[--z]', 'ruby/1.9')
    set   = root[0]
    range = set[0]

    assert_equal 1, set.count
    assert_equal 2, range.count
    assert_equal true, set.matches?('a')
  end

  def test_parse_set_range_edge_case_trailing_dash
    root  = RP.parse('[!--]', 'ruby/1.9')
    set   = root[0]
    range = set[0]

    assert_equal 1, set.count
    assert_equal 2, range.count
    assert_equal true, set.matches?('$')
  end

  def test_parse_set_range_edge_case_leading_negate
    root = RP.parse('[^-z]', 'ruby/1.9')
    set  = root[0]

    assert_equal 2, set.count
    assert_equal true, set.matches?('a')
    assert_equal false, set.matches?('z')
  end

  def test_parse_set_range_edge_case_trailing_negate
    root  = RP.parse('[!-^]', 'ruby/1.9')
    set   = root[0]
    range = set[0]

    assert_equal 1, set.count
    assert_equal 2, range.count
    assert_equal true, set.matches?('$')
  end

  def test_parse_set_range_edge_case_leading_intersection
    root  = RP.parse('[[\-ab]&&-bc]', 'ruby/1.9')
    set   = root[0]

    assert_equal 3, set.count
    assert_equal '[\-ab]&&-', set.first.to_s
    assert_equal true, set.matches?('-')
    assert_equal true, set.matches?('b')
    assert_equal false, set.matches?('a')
    assert_equal false, set.matches?('c')
  end

  def test_parse_set_range_edge_case_trailing_intersection
    root  = RP.parse('[bc-&&[\-ab]]', 'ruby/1.9')
    set   = root[0]

    assert_equal 3, set.count
    assert_equal '-&&[\-ab]', set.last.to_s
    assert_equal true, set.matches?('-')
    assert_equal true, set.matches?('b')
    assert_equal false, set.matches?('a')
    assert_equal false, set.matches?('c')
  end
end
