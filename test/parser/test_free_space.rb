require File.expand_path("../../helpers", __FILE__)

class ParserFreeSpace < Test::Unit::TestCase

  def test_parse_free_space_spaces
    regexp = /a ? b * c + d{2,4}/x
    root   = RP.parse(regexp)

    0.upto(6) do |i|
      if i.odd?
        # Consecutive spaces get merged by the parser, thus the two spaces.
        assert_equal WhiteSpace, root[i].class
        assert_equal '  ',       root[i].text
      else
        assert_equal Literal, root[i].class
        assert_equal true,    root[i].quantified?
      end
    end
  end

  def test_parse_non_free_space_literals
    regexp = /a b c d/
    root   = RP.parse(regexp)

    assert_equal Literal,    root.first.class
    assert_equal 'a b c d',  root.first.text
  end

  def test_parse_free_space_comments
    regexp = %r{
      a   ?     # One letter
      b {2,5}   # Another one
      [c-g]  +  # A set
      (h|i|j) | # A group
      klm *
      nop +
    }x

    root = RP.parse(regexp)

    alt = root.first
    assert_equal Alternation, alt.class

    alt_1 = alt.alternatives.first
    assert_equal Alternative, alt_1.class
    assert_equal 15, alt_1.length

    [0, 2, 4, 6, 8, 12, 14].each do |i|
      assert_equal WhiteSpace, alt_1[i].class
    end

    [3, 7, 11].each do |i|
      assert_equal Comment, alt_1[i].class
    end

    alt_2 = alt.alternatives.last
    assert_equal Alternative, alt_2.class
    assert_equal 7, alt_2.length

    [0, 2, 4, 6].each do |i|
      assert_equal WhiteSpace, alt_2[i].class
    end

    assert_equal Comment, alt_2[1].class
  end

  def test_parse_free_space_nested_comments
    # Tests depend on spacing and indentation, obviously.
    regexp = %r{
      # Group one
      (
       abc  # Comment one
       \d?  # Optional \d
      )+

      # Group two
      (
       def  # Comment two
       \s?  # Optional \s
      )?
    }x

    root = RP.parse(regexp)

    top_comment_1 = root[1]
    assert_equal Comment,         top_comment_1.class
    assert_equal "# Group one\n", top_comment_1.text
    assert_equal 7,               top_comment_1.starts_at

    top_comment_2 = root[5]
    assert_equal Comment,         top_comment_2.class
    assert_equal "# Group two\n", top_comment_2.text
    assert_equal 95,              top_comment_2.starts_at

    # Nested comments
    [3, 7].each_with_index do |g, i|
      group = root[g]

      [3, 7].each do |c|
        comment = group[c]
        assert_equal Comment, comment.class
        assert_equal 14,      comment.text.length
      end
    end
  end

  def test_parse_free_space_quantifiers
    regexp = %r{
      a
      # comment 1
      ?
      (
       b # comment 2
       # comment 3
       +
      )
      # comment 4
      *
    }x

    root = RP.parse(regexp)

    literal_1 = root[1]
    assert_equal Literal,        literal_1.class
    assert_equal true,           literal_1.quantified?
    assert_equal :zero_or_one,   literal_1.quantifier.token

    group = root[5]
    assert_equal Group::Capture, group.class
    assert_equal true,           group.quantified?
    assert_equal :zero_or_more,  group.quantifier.token

    literal_2 = group[1]
    assert_equal Literal,        literal_2.class
    assert_equal true,           literal_2.quantified?
    assert_equal :one_or_more,   literal_2.quantifier.token
  end

end
