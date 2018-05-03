require File.expand_path('../../../helpers', __FILE__)

class ParserSetRangs < Test::Unit::TestCase
  def test_parse_set_range
    root  = RP.parse('[a-z]')
    set   = root[0]
    range = set[0]

    assert_equal 1, set.count
    assert_equal CharacterSet::Range, range.class
    assert_equal 2, range.count
    assert_equal 'a', range.first.to_s
    assert_equal Literal, range.first.class
    assert_equal 'z', range.last.to_s
    assert_equal Literal, range.last.class
    assert       set.matches?('m')
  end

  def test_parse_set_range_hex
    root  = RP.parse('[\x00-\x99]')
    set   = root[0]
    range = set[0]

    assert_equal 1, set.count
    assert_equal CharacterSet::Range, range.class
    assert_equal 2, range.count
    assert_equal '\x00', range.first.to_s
    assert_equal EscapeSequence::Hex, range.first.class
    assert_equal '\x99', range.last.to_s
    assert_equal EscapeSequence::Hex, range.last.class
    assert       set.matches?('\x50')
  end

  def test_parse_set_range_unicode
    root  = RP.parse('[\u{40 42}-\u1234]')
    set   = root[0]
    range = set[0]

    assert_equal 1, set.count
    assert_equal CharacterSet::Range, range.class
    assert_equal 2, range.count
    assert_equal '\u{40 42}', range.first.to_s
    assert_equal EscapeSequence::CodepointList, range.first.class
    assert_equal '\u1234', range.last.to_s
    assert_equal EscapeSequence::Codepoint, range.last.class
    assert       set.matches?('\u600')
  end

  def test_parse_set_range_edge_case_leading_dash
    root  = RP.parse('[--z]')
    set   = root[0]
    range = set[0]

    assert_equal 1, set.count
    assert_equal 2, range.count
    assert       set.matches?('a')
  end

  def test_parse_set_range_edge_case_trailing_dash
    root  = RP.parse('[!--]')
    set   = root[0]
    range = set[0]

    assert_equal 1, set.count
    assert_equal 2, range.count
    assert       set.matches?('$')
  end

  def test_parse_set_range_edge_case_leading_negate
    root = RP.parse('[^-z]')
    set  = root[0]

    assert_equal 2, set.count
    assert       set.matches?('a')
    refute       set.matches?('z')
  end

  def test_parse_set_range_edge_case_trailing_negate
    root  = RP.parse('[!-^]')
    set   = root[0]
    range = set[0]

    assert_equal 1, set.count
    assert_equal 2, range.count
    assert       set.matches?('$')
  end

  def test_parse_set_range_edge_case_leading_intersection
    root  = RP.parse('[[\-ab]&&-bc]')
    set   = root[0]

    assert_equal 1, set.count
    assert_equal '-bc', set.first.last.to_s
    assert       set.matches?('-')
    assert       set.matches?('b')
    refute       set.matches?('a')
    refute       set.matches?('c')
  end

  def test_parse_set_range_edge_case_trailing_intersection
    root  = RP.parse('[bc-&&[\-ab]]')
    set   = root[0]

    assert_equal 1, set.count
    assert_equal 'bc-', set.first.first.to_s
    assert       set.matches?('-')
    assert       set.matches?('b')
    refute       set.matches?('a')
    refute       set.matches?('c')
  end
end
