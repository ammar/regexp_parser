require File.expand_path('../../../helpers', __FILE__)

class ParserSetIntersections < Test::Unit::TestCase
  def test_parse_set_intersection
    root = RP.parse('[a&&z]')
    set  = root[0]
    ints = set[0]

    assert_equal 1, set.count
    assert_equal CharacterSet::Intersection, ints.class
    assert_equal 2, ints.count
    assert_equal 'a', ints.first.to_s
    assert_equal Literal, ints.first.class
    assert_equal 'z', ints.last.to_s
    assert_equal Literal, ints.last.class
    refute       set.matches?('a')
    refute       set.matches?('&')
    refute       set.matches?('z')
  end

  def test_parse_set_intersection_range_and_subset
    root = RP.parse('[a-z&&[^a]]')
    set  = root[0]
    ints = set[0]

    assert_equal 1, set.count
    assert_equal CharacterSet::Intersection, ints.class
    assert_equal 2, ints.count
    assert_equal 'a-z', ints.first.to_s
    assert_equal CharacterSet::Range, ints.first.class
    assert_equal '[^a]', ints.last.to_s
    assert_equal CharacterSet, ints.last.class
    refute       set.matches?('a')
    refute       set.matches?('&')
    assert       set.matches?('b')
  end

  def test_parse_set_intersection_type
    root = RP.parse('[a&&\w]')
    set  = root[0]
    ints = set[0]

    assert_equal 1, set.count
    assert_equal CharacterSet::Intersection, ints.class
    assert_equal 2, ints.count
    assert_equal 'a', ints.first.to_s
    assert_equal Literal, ints.first.class
    assert_equal '\w', ints.last.to_s
    assert_equal CharacterType::Word, ints.last.class
    assert       set.matches?('a')
    refute       set.matches?('&')
    refute       set.matches?('b')
  end
end
