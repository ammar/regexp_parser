require File.expand_path("../../helpers", __FILE__)

class TestRegexpParserQuantifiers < Test::Unit::TestCase

  # ?: zero-or-one
  def test_parse_zero_or_one_greedy
    root = RP.parse('a?bc')
    exp  = root.expressions.first

    assert_equal true,          exp.quantified?
    assert_equal :zero_or_one,  exp.quantifier.token
    assert_equal 0,             exp.quantifier.min
    assert_equal 1,             exp.quantifier.max
    assert_equal :greedy,       exp.quantifier.mode
  end

  def test_parse_zero_or_one_reluctant
    root = RP.parse('a??bc')
    exp  = root.expressions.first

    assert_equal true,          exp.quantified?
    assert_equal :zero_or_one,  exp.quantifier.token
    assert_equal 0,             exp.quantifier.min
    assert_equal 1,             exp.quantifier.max
    assert_equal :reluctant,    exp.quantifier.mode
    assert_equal true,          exp.reluctant?
  end

  def test_parse_zero_or_one_possessive
    root = RP.parse('a?+bc', 'ruby/1.9')
    exp  = root.expressions.first

    assert_equal true,          exp.quantified?
    assert_equal :zero_or_one,  exp.quantifier.token
    assert_equal 0,             exp.quantifier.min
    assert_equal 1,             exp.quantifier.max
    assert_equal :possessive,   exp.quantifier.mode
    assert_equal true,          exp.possessive?
  end

  # *: zero-or-more
  def test_parse_zero_or_more_greedy
    root = RP.parse('a*bc')
    exp  = root.expressions.first

    assert_equal true,          exp.quantified?
    assert_equal :zero_or_more, exp.quantifier.token
    assert_equal 0,             exp.quantifier.min
    assert_equal(-1,            exp.quantifier.max)
    assert_equal :greedy,       exp.quantifier.mode
  end

  def test_parse_zero_or_more_reluctant
    root = RP.parse('a*?bc')
    exp  = root.expressions.first

    assert_equal true,          exp.quantified?
    assert_equal :zero_or_more, exp.quantifier.token
    assert_equal 0,             exp.quantifier.min
    assert_equal(-1,            exp.quantifier.max)
    assert_equal :reluctant,    exp.quantifier.mode
    assert_equal true,          exp.reluctant?
  end

  def test_parse_zero_or_more_possessive
    root = RP.parse('a*+bc', 'ruby/1.9')
    exp  = root.expressions.first

    assert_equal true,          exp.quantified?
    assert_equal :zero_or_more, exp.quantifier.token
    assert_equal 0,             exp.quantifier.min
    assert_equal(-1,            exp.quantifier.max)
    assert_equal :possessive,   exp.quantifier.mode
    assert_equal true,          exp.possessive?
  end

  # +: one-or-more
  def test_parse_one_or_more_greedy
    root = RP.parse('a+bc')
    exp  = root.expressions.first

    assert_equal true,          exp.quantified?
    assert_equal :one_or_more,  exp.quantifier.token
    assert_equal 1,             exp.quantifier.min
    assert_equal(-1,            exp.quantifier.max)
    assert_equal :greedy,       exp.quantifier.mode
  end

  def test_parse_one_or_more_reluctant
    root = RP.parse('a+?bc')
    exp  = root.expressions.first

    assert_equal true,          exp.quantified?
    assert_equal :one_or_more,  exp.quantifier.token
    assert_equal 1,             exp.quantifier.min
    assert_equal(-1,            exp.quantifier.max)
    assert_equal :reluctant,    exp.quantifier.mode
    assert_equal true,          exp.reluctant?
  end

  def test_parse_one_or_more_possessive
    root = RP.parse('a++bc', 'ruby/1.9')
    exp  = root.expressions.first

    assert_equal true,          exp.quantified?
    assert_equal :one_or_more,  exp.quantifier.token
    assert_equal 1,             exp.quantifier.min
    assert_equal(-1,            exp.quantifier.max)
    assert_equal :possessive,   exp.quantifier.mode
    assert_equal true,          exp.possessive?
  end

  # interval: min and max
  def test_parse_intervals_min_max_greedy
    root = RP.parse('a{2,4}bc')
    exp  = root.expressions.first

    assert_equal true,      exp.quantified?
    assert_equal :interval, exp.quantifier.token
    assert_equal 2,         exp.quantifier.min
    assert_equal 4,         exp.quantifier.max
    assert_equal :greedy,   exp.quantifier.mode
  end

  def test_parse_intervals_min_max_reluctant
    root = RP.parse('a{3,5}?bc')
    exp  = root.expressions.first

    assert_equal true,        exp.quantified?
    assert_equal :interval,   exp.quantifier.token
    assert_equal 3,           exp.quantifier.min
    assert_equal 5,           exp.quantifier.max
    assert_equal :reluctant,  exp.quantifier.mode
    assert_equal true,        exp.reluctant?
  end

  def test_parse_intervals_min_max_possessive
    root = RP.parse('a{2,4}+bc', 'ruby/1.9')
    exp  = root.expressions.first

    assert_equal true,        exp.quantified?
    assert_equal :interval,   exp.quantifier.token
    assert_equal 2,           exp.quantifier.min
    assert_equal 4,           exp.quantifier.max
    assert_equal :possessive, exp.quantifier.mode
    assert_equal true,        exp.possessive?
  end

  # interval: min only
  def test_parse_intervals_min_only_greedy
    root = RP.parse('a{2,}bc')
    exp  = root.expressions.first

    assert_equal true,      exp.quantified?
    assert_equal :interval, exp.quantifier.token
    assert_equal 2,         exp.quantifier.min
    assert_equal(-1,        exp.quantifier.max)
    assert_equal :greedy,   exp.quantifier.mode
  end

  def test_parse_intervals_min_only_reluctant
    root = RP.parse('a{2,}?bc')
    exp  = root.expressions.first

    assert_equal true,        exp.quantified?
    assert_equal :interval,   exp.quantifier.token
    assert_equal '{2,}?',     exp.quantifier.text
    assert_equal 2,           exp.quantifier.min
    assert_equal(-1,          exp.quantifier.max)
    assert_equal :reluctant,  exp.quantifier.mode
    assert_equal true,        exp.reluctant?
  end

  def test_parse_intervals_min_only_possessive
    root = RP.parse('a{3,}+bc', 'ruby/1.9')
    exp  = root.expressions.first

    assert_equal true,        exp.quantified?
    assert_equal :interval,   exp.quantifier.token
    assert_equal '{3,}+',     exp.quantifier.text
    assert_equal 3,           exp.quantifier.min
    assert_equal(-1,          exp.quantifier.max)
    assert_equal :possessive, exp.quantifier.mode
    assert_equal true,        exp.possessive?
  end

  # interval: max only
  def test_parse_intervals_max_only_greedy
    root = RP.parse('a{,2}bc')
    exp  = root.expressions.first

    assert_equal true,      exp.quantified?
    assert_equal :interval, exp.quantifier.token
    assert_equal 0,         exp.quantifier.min
    assert_equal 2,         exp.quantifier.max
    assert_equal :greedy,   exp.quantifier.mode
  end

  def test_parse_intervals_max_only_reluctant
    root = RP.parse('a{,4}?bc')
    exp  = root.expressions.first

    assert_equal true,        exp.quantified?
    assert_equal :interval,   exp.quantifier.token
    assert_equal 0,           exp.quantifier.min
    assert_equal 4,           exp.quantifier.max
    assert_equal :reluctant,  exp.quantifier.mode
    assert_equal true,        exp.reluctant?
  end

  def test_parse_intervals_max_only_possessive
    root = RP.parse('a{,3}+bc', 'ruby/1.9')
    exp  = root.expressions.first

    assert_equal true,        exp.quantified?
    assert_equal :interval,   exp.quantifier.token
    assert_equal 0,           exp.quantifier.min
    assert_equal 3,           exp.quantifier.max
    assert_equal :possessive, exp.quantifier.mode
    assert_equal true,        exp.possessive?
  end

  # interval: exact
  def test_parse_intervals_exact_greedy
    root = RP.parse('a{2}bc')
    exp  = root.expressions.first

    assert_equal true,      exp.quantified?
    assert_equal :interval, exp.quantifier.token
    assert_equal 2,         exp.quantifier.min
    assert_equal 2,         exp.quantifier.max
    assert_equal :greedy,   exp.quantifier.mode
  end

  def test_parse_intervals_exact_reluctant
    root = RP.parse('a{3}?bc')
    exp  = root.expressions.first

    assert_equal true,        exp.quantified?
    assert_equal :interval,   exp.quantifier.token
    assert_equal 3,           exp.quantifier.min
    assert_equal 3,           exp.quantifier.max
    assert_equal :reluctant,  exp.quantifier.mode
    assert_equal true,        exp.reluctant?
  end

  def test_parse_intervals_exact_possessive
    root = RP.parse('a{3}+bc', 'ruby/1.9')
    exp  = root.expressions.first

    assert_equal true,        exp.quantified?
    assert_equal :interval,   exp.quantifier.token
    assert_equal 3,           exp.quantifier.min
    assert_equal 3,           exp.quantifier.max
    assert_equal :possessive, exp.quantifier.mode
    assert_equal true,        exp.possessive?
  end

end
