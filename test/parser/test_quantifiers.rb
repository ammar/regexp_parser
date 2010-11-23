require File.expand_path("../../helpers", __FILE__)

class TestRegexpParserQuantifiers < Test::Unit::TestCase

  # ?: zero-or-one
  def test_parse_zero_or_one_greedy
    t = RP.parse('a?bc')

    assert_equal( true, t.expressions.first.quantified? )
    assert_equal( :zero_or_one, t.expressions.first.quantifier.token )
    assert_equal( 0, t.expressions.first.quantifier.min )
    assert_equal( 1, t.expressions.first.quantifier.max )
    assert_equal( :greedy, t.expressions.first.quantifier.mode )
  end

  def test_parse_zero_or_one_reluctant
    t = RP.parse('a??bc')

    assert_equal( true, t.expressions.first.quantified? )
    assert_equal( :zero_or_one, t.expressions.first.quantifier.token )
    assert_equal( 0, t.expressions.first.quantifier.min )
    assert_equal( 1, t.expressions.first.quantifier.max )
    assert_equal( :reluctant, t.expressions.first.quantifier.mode )
    assert_equal( true, t.expressions.first.reluctant? )
  end

  def test_parse_zero_or_one_possessive
    t = RP.parse('a?+bc', 'ruby/1.9')

    assert_equal( true, t.expressions.first.quantified? )
    assert_equal( :zero_or_one, t.expressions.first.quantifier.token )
    assert_equal( 0, t.expressions.first.quantifier.min )
    assert_equal( 1, t.expressions.first.quantifier.max )
    assert_equal( :possessive, t.expressions.first.quantifier.mode )
    assert_equal( true, t.expressions.first.possessive? )
  end

  # *: zero-or-more
  def test_parse_zero_or_more_greedy
    t = RP.parse('a*bc')

    assert_equal( true, t.expressions.first.quantified? )
    assert_equal( :zero_or_more, t.expressions.first.quantifier.token )
    assert_equal( 0, t.expressions.first.quantifier.min )
    assert_equal( -1, t.expressions.first.quantifier.max )
    assert_equal( :greedy, t.expressions.first.quantifier.mode )
  end

  def test_parse_zero_or_more_reluctant
    t = RP.parse('a*?bc')

    assert_equal( true, t.expressions.first.quantified? )
    assert_equal( :zero_or_more, t.expressions.first.quantifier.token )
    assert_equal( 0, t.expressions.first.quantifier.min )
    assert_equal( -1, t.expressions.first.quantifier.max )
    assert_equal( :reluctant, t.expressions.first.quantifier.mode )
    assert_equal( true, t.expressions.first.reluctant? )
  end

  def test_parse_zero_or_more_possessive
    t = RP.parse('a*+bc', 'ruby/1.9')

    assert_equal( true, t.expressions.first.quantified? )
    assert_equal( :zero_or_more, t.expressions.first.quantifier.token )
    assert_equal( 0, t.expressions.first.quantifier.min )
    assert_equal( -1, t.expressions.first.quantifier.max )
    assert_equal( :possessive, t.expressions.first.quantifier.mode )
    assert_equal( true, t.expressions.first.possessive? )
  end

  # +: one-or-more
  def test_parse_one_or_more_greedy
    t = RP.parse('a+bc')

    assert_equal( true, t.expressions.first.quantified? )
    assert_equal( :one_or_more, t.expressions.first.quantifier.token )
    assert_equal( 1, t.expressions.first.quantifier.min )
    assert_equal( -1, t.expressions.first.quantifier.max )
    assert_equal( :greedy, t.expressions.first.quantifier.mode )
  end

  def test_parse_one_or_more_reluctant
    t = RP.parse('a+?bc')

    assert_equal( true, t.expressions.first.quantified? )
    assert_equal( :one_or_more, t.expressions.first.quantifier.token )
    assert_equal( 1, t.expressions.first.quantifier.min )
    assert_equal( -1, t.expressions.first.quantifier.max )
    assert_equal( :reluctant, t.expressions.first.quantifier.mode )
    assert_equal( true, t.expressions.first.reluctant? )
  end

  def test_parse_one_or_more_possessive
    t = RP.parse('a++bc', 'ruby/1.9')

    assert_equal( true, t.expressions.first.quantified? )
    assert_equal( :one_or_more, t.expressions.first.quantifier.token )
    assert_equal( 1, t.expressions.first.quantifier.min )
    assert_equal( -1, t.expressions.first.quantifier.max )
    assert_equal( :possessive, t.expressions.first.quantifier.mode )
    assert_equal( true, t.expressions.first.possessive? )
  end

  # interval: min and max
  def test_parse_intervals_min_max_greedy
    t = RP.parse('a{2,4}bc')

    assert_equal( true, t.expressions.first.quantified? )
    assert_equal( :interval, t.expressions.first.quantifier.token )
    assert_equal( 2, t.expressions.first.quantifier.min)
    assert_equal( 4, t.expressions.first.quantifier.max)
    assert_equal( :greedy, t.expressions.first.quantifier.mode )
  end

  def test_parse_intervals_min_max_reluctant
    t = RP.parse('a{3,5}?bc')

    assert_equal( true, t.expressions.first.quantified? )
    assert_equal( :interval, t.expressions.first.quantifier.token )
    assert_equal( 3, t.expressions.first.quantifier.min)
    assert_equal( 5, t.expressions.first.quantifier.max)
    assert_equal( :reluctant, t.expressions.first.quantifier.mode )
    assert_equal( true, t.expressions.first.reluctant? )
  end

  def test_parse_intervals_min_max_possessive
    t = RP.parse('a{2,4}+bc', 'ruby/1.9')

    assert_equal( true, t.expressions.first.quantified? )
    assert_equal( :interval, t.expressions.first.quantifier.token )
    assert_equal( 2, t.expressions.first.quantifier.min)
    assert_equal( 4, t.expressions.first.quantifier.max)
    assert_equal( :possessive, t.expressions.first.quantifier.mode )
    assert_equal( true, t.expressions.first.possessive? )
  end

  # interval: min only
  def test_parse_intervals_min_only_greedy
    t = RP.parse('a{2,}bc')

    assert_equal( true, t.expressions.first.quantified? )
    assert_equal( :interval, t.expressions.first.quantifier.token )
    assert_equal( 2, t.expressions.first.quantifier.min)
    assert_equal( -1, t.expressions.first.quantifier.max)
    assert_equal( :greedy, t.expressions.first.quantifier.mode )
  end

  def test_parse_intervals_min_only_reluctant
    t = RP.parse('a{2,}?bc')

    assert_equal( true, t.expressions.first.quantified? )
    assert_equal( :interval, t.expressions.first.quantifier.token )
    assert_equal( 2, t.expressions.first.quantifier.min)
    assert_equal( -1, t.expressions.first.quantifier.max)
    assert_equal( :reluctant, t.expressions.first.quantifier.mode )
    assert_equal( true, t.expressions.first.reluctant? )
  end

  def test_parse_intervals_min_only_possessive
    t = RP.parse('a{3,}+bc', 'ruby/1.9')

    assert_equal( true, t.expressions.first.quantified? )
    assert_equal( :interval, t.expressions.first.quantifier.token )
    assert_equal( 3, t.expressions.first.quantifier.min)
    assert_equal( -1, t.expressions.first.quantifier.max)
    assert_equal( :possessive, t.expressions.first.quantifier.mode )
    assert_equal( true, t.expressions.first.possessive? )
  end

  # interval: max only
  def test_parse_intervals_max_only_greedy
    t = RP.parse('a{,2}bc')

    assert_equal( true, t.expressions.first.quantified? )
    assert_equal( :interval, t.expressions.first.quantifier.token )
    assert_equal( 0, t.expressions.first.quantifier.min)
    assert_equal( 2, t.expressions.first.quantifier.max)
    assert_equal( :greedy, t.expressions.first.quantifier.mode )
  end

  def test_parse_intervals_max_only_reluctant
    t = RP.parse('a{,4}?bc')

    assert_equal( true, t.expressions.first.quantified? )
    assert_equal( :interval, t.expressions.first.quantifier.token )
    assert_equal( 0, t.expressions.first.quantifier.min)
    assert_equal( 4, t.expressions.first.quantifier.max)
    assert_equal( :reluctant, t.expressions.first.quantifier.mode )
    assert_equal( true, t.expressions.first.reluctant? )
  end

  def test_parse_intervals_max_only_possessive
    t = RP.parse('a{,3}+bc', 'ruby/1.9')

    assert_equal( true, t.expressions.first.quantified? )
    assert_equal( :interval, t.expressions.first.quantifier.token )
    assert_equal( 0, t.expressions.first.quantifier.min)
    assert_equal( 3, t.expressions.first.quantifier.max)
    assert_equal( :possessive, t.expressions.first.quantifier.mode )
    assert_equal( true, t.expressions.first.possessive? )
  end

  # interval: exact
  def test_parse_intervals_exact_greedy
    t = RP.parse('a{2}bc')

    assert_equal( true, t.expressions.first.quantified? )
    assert_equal( :interval, t.expressions.first.quantifier.token )
    assert_equal( 2, t.expressions.first.quantifier.min)
    assert_equal( 2, t.expressions.first.quantifier.max)
    assert_equal( :greedy, t.expressions.first.quantifier.mode )
  end

  def test_parse_intervals_exact_reluctant
    t = RP.parse('a{3}?bc')

    assert_equal( true, t.expressions.first.quantified? )
    assert_equal( :interval, t.expressions.first.quantifier.token )
    assert_equal( 3, t.expressions.first.quantifier.min)
    assert_equal( 3, t.expressions.first.quantifier.max)
    assert_equal( :reluctant, t.expressions.first.quantifier.mode )
    assert_equal( true, t.expressions.first.reluctant? )
  end

  def test_parse_intervals_exact_possessive
    t = RP.parse('a{3}+bc', 'ruby/1.9')

    assert_equal( true, t.expressions.first.quantified? )
    assert_equal( :interval, t.expressions.first.quantifier.token )
    assert_equal( 3, t.expressions.first.quantifier.min)
    assert_equal( 3, t.expressions.first.quantifier.max)
    assert_equal( :possessive, t.expressions.first.quantifier.mode )
    assert_equal( true, t.expressions.first.possessive? )
  end

end
