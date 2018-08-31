require File.expand_path('../../../helpers', __FILE__)

# edge cases with `...-&&...` and `...&&-...` are checked in test_ranges.rb

class ParserSetIntersections < Test::Unit::TestCase
  def test_parse_set_intersection
    root = RP.parse('[a&&z]')
    set  = root[0]
    ints = set[0]

    assert_equal 1, set.count
    assert_equal CharacterSet::Intersection, ints.class
    assert_equal 2, ints.count

    seq1, seq2 = ints.expressions
    assert_equal CharacterSet::IntersectedSequence, seq1.class
    assert_equal 1, seq1.count
    assert_equal 'a', seq1.first.to_s
    assert_equal Literal, seq1.first.class
    assert_equal CharacterSet::IntersectedSequence, seq2.class
    assert_equal 1, seq2.count
    assert_equal 'z', seq2.first.to_s
    assert_equal Literal, seq2.first.class

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

    seq1, seq2 = ints.expressions
    assert_equal CharacterSet::IntersectedSequence, seq1.class
    assert_equal 1, seq1.count
    assert_equal 'a-z', seq1.first.to_s
    assert_equal CharacterSet::Range, seq1.first.class
    assert_equal CharacterSet::IntersectedSequence, seq2.class
    assert_equal 1, seq2.count
    assert_equal '[^a]', seq2.first.to_s
    assert_equal CharacterSet, seq2.first.class

    refute       set.matches?('a')
    refute       set.matches?('&')
    assert       set.matches?('b')
  end

  def test_parse_set_intersection_trailing_range
    root = RP.parse('[a&&a-z]')
    set  = root[0]
    ints = set[0]

    assert_equal 1, set.count
    assert_equal CharacterSet::Intersection, ints.class
    assert_equal 2, ints.count

    seq1, seq2 = ints.expressions
    assert_equal CharacterSet::IntersectedSequence, seq1.class
    assert_equal 1, seq1.count
    assert_equal 'a', seq1.first.to_s
    assert_equal Literal, seq1.first.class
    assert_equal CharacterSet::IntersectedSequence, seq2.class
    assert_equal 1, seq2.count
    assert_equal 'a-z', seq2.first.to_s
    assert_equal CharacterSet::Range, seq2.first.class

    assert       set.matches?('a')
    refute       set.matches?('&')
    refute       set.matches?('b')
  end

  def test_parse_set_intersection_type
    root = RP.parse('[a&&\w]')
    set  = root[0]
    ints = set[0]

    assert_equal 1, set.count
    assert_equal CharacterSet::Intersection, ints.class
    assert_equal 2, ints.count

    seq1, seq2 = ints.expressions
    assert_equal CharacterSet::IntersectedSequence, seq1.class
    assert_equal 1, seq1.count
    assert_equal 'a', seq1.first.to_s
    assert_equal Literal, seq1.first.class
    assert_equal CharacterSet::IntersectedSequence, seq2.class
    assert_equal 1, seq2.count
    assert_equal '\w', seq2.first.to_s
    assert_equal CharacterType::Word, seq2.first.class

    assert       set.matches?('a')
    refute       set.matches?('&')
    refute       set.matches?('b')
  end

  def test_parse_set_intersection_multipart
    root = RP.parse('[\h&&\w&&efg]')
    set  = root[0]
    ints = set[0]

    assert_equal 1, set.count
    assert_equal CharacterSet::Intersection, ints.class
    assert_equal 3, ints.count

    seq1, seq2, seq3 = ints.expressions
    assert_equal CharacterSet::IntersectedSequence, seq1.class
    assert_equal 1, seq1.count
    assert_equal '\h', seq1.first.to_s
    assert_equal CharacterSet::IntersectedSequence, seq2.class
    assert_equal 1, seq2.count
    assert_equal '\w', seq2.first.to_s
    assert_equal CharacterSet::IntersectedSequence, seq3.class
    assert_equal 3, seq3.count
    assert_equal 'efg', seq3.to_s

    assert       set.matches?('e')
    assert       set.matches?('f')
    refute       set.matches?('a')
    refute       set.matches?('g')
  end
end
