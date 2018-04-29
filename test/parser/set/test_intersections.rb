require File.expand_path('../../../helpers', __FILE__)

class ParserSetIntersections < Test::Unit::TestCase
  def test_parse_set_intersection
    root = RP.parse('[a&&z]', 'ruby/1.9')
    set  = root[0]
    ints = set[0]

    assert_equal 1, set.count
    assert_equal CharacterSet::Intersection, ints.class
    assert_equal 2, ints.count
    assert_equal 'a', ints.first.to_s
    assert_equal Literal, ints.first.class
    assert_equal 'z', ints.last.to_s
    assert_equal Literal, ints.last.class
    assert_equal false, set.matches?('a')
  end

  def test_parse_set_intersection_range_and_subset
    root = RP.parse('[a-z&&[^a]]', 'ruby/1.9')
    set  = root[0]
    ints = set[0]

    assert_equal 1, set.count
    assert_equal CharacterSet::Intersection, ints.class
    assert_equal 2, ints.count
    assert_equal 'a-z', ints.first.to_s
    assert_equal CharacterSet::Range, ints.first.class
    assert_equal '[^a]', ints.last.to_s
    assert_equal CharacterSet, ints.last.class
    assert_equal false, set.matches?('a')
    assert_equal true, set.matches?('b')
  end

  def test_parse_set_intersection_type
    root = RP.parse('[a&&\w]', 'ruby/1.9')
    set  = root[0]
    ints = set[0]

    assert_equal 1, set.count
    assert_equal CharacterSet::Intersection, ints.class
    assert_equal 2, ints.count
    assert_equal 'a', ints.first.to_s
    assert_equal Literal, ints.first.class
    assert_equal '\w', ints.last.to_s
    assert_equal CharacterType::Word, ints.last.class
    assert_equal true, set.matches?('a')
    assert_equal false, set.matches?('b')
  end
end
