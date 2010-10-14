require "test/unit"
require File.expand_path("../../lib/regexp_parser.rb", __FILE__)

RP = Regexp::Parser

class TestRegexpParserQuantifiers < Test::Unit::TestCase

  # ?: zero-or-one
  def test_parse_zero_or_one_basic
    t = RP.parse('a?bc')

    assert_equal( true, t.expressions.first.quantified? )
    assert_equal( :zero_or_one, t.expressions.first.quantifier )
    assert_equal( 0, t.expressions.first.min )
    assert_equal( 1, t.expressions.first.max )
    assert_equal( :basic, t.expressions.first.quantifier_mode )
  end

  def test_parse_zero_or_one_reluctant
    t = RP.parse('a??bc')

    assert_equal( true, t.expressions.first.quantified? )
    assert_equal( :zero_or_one, t.expressions.first.quantifier )
    assert_equal( 0, t.expressions.first.min )
    assert_equal( 1, t.expressions.first.max )
    assert_equal( :reluctant, t.expressions.first.quantifier_mode )
    assert_equal( true, t.expressions.first.reluctant? )
  end

  def test_parse_zero_or_one_possessive
    t = RP.parse('a?+bc')

    assert_equal( true, t.expressions.first.quantified? )
    assert_equal( :zero_or_one, t.expressions.first.quantifier )
    assert_equal( 0, t.expressions.first.min )
    assert_equal( 1, t.expressions.first.max )
    assert_equal( :possessive, t.expressions.first.quantifier_mode )
    assert_equal( true, t.expressions.first.possessive? )
  end

  # *: zero-or-more
  def test_parse_zero_or_more_basic
    t = RP.parse('a*bc')

    assert_equal( true, t.expressions.first.quantified? )
    assert_equal( :zero_or_more, t.expressions.first.quantifier )
    assert_equal( 0, t.expressions.first.min )
    assert_equal( -1, t.expressions.first.max )
    assert_equal( :basic, t.expressions.first.quantifier_mode )
  end

  def test_parse_zero_or_more_reluctant
    t = RP.parse('a*?bc')

    assert_equal( true, t.expressions.first.quantified? )
    assert_equal( :zero_or_more, t.expressions.first.quantifier )
    assert_equal( 0, t.expressions.first.min )
    assert_equal( -1, t.expressions.first.max )
    assert_equal( :reluctant, t.expressions.first.quantifier_mode )
    assert_equal( true, t.expressions.first.reluctant? )
  end

  def test_parse_zero_or_more_possessive
    t = RP.parse('a*+bc')

    assert_equal( true, t.expressions.first.quantified? )
    assert_equal( :zero_or_more, t.expressions.first.quantifier )
    assert_equal( 0, t.expressions.first.min )
    assert_equal( -1, t.expressions.first.max )
    assert_equal( :possessive, t.expressions.first.quantifier_mode )
    assert_equal( true, t.expressions.first.possessive? )
  end

  # +: one-or-more
  def test_parse_one_or_more_basic
    t = RP.parse('a+bc')

    assert_equal( true, t.expressions.first.quantified? )
    assert_equal( :one_or_more, t.expressions.first.quantifier )
    assert_equal( 1, t.expressions.first.min )
    assert_equal( -1, t.expressions.first.max )
    assert_equal( :basic, t.expressions.first.quantifier_mode )
  end

  def test_parse_one_or_more_reluctant
    t = RP.parse('a+?bc')

    assert_equal( true, t.expressions.first.quantified? )
    assert_equal( :one_or_more, t.expressions.first.quantifier )
    assert_equal( 1, t.expressions.first.min )
    assert_equal( -1, t.expressions.first.max )
    assert_equal( :reluctant, t.expressions.first.quantifier_mode )
    assert_equal( true, t.expressions.first.reluctant? )
  end

  def test_parse_one_or_more_possessive
    t = RP.parse('a++bc')

    assert_equal( true, t.expressions.first.quantified? )
    assert_equal( :one_or_more, t.expressions.first.quantifier )
    assert_equal( 1, t.expressions.first.min )
    assert_equal( -1, t.expressions.first.max )
    assert_equal( :possessive, t.expressions.first.quantifier_mode )
    assert_equal( true, t.expressions.first.possessive? )
  end

  # repetition: min and max
  def test_parse_repetitions_min_max_basic
    t = RP.parse('a{2,4}bc')

    assert_equal( true, t.expressions.first.quantified? )
    assert_equal( :repetition, t.expressions.first.quantifier )
    assert_equal( 2, t.expressions.first.min)
    assert_equal( 4, t.expressions.first.max)
    assert_equal( :basic, t.expressions.first.quantifier_mode )
  end

  def test_parse_repetitions_min_max_reluctant
    t = RP.parse('a{3,5}?bc')

    assert_equal( true, t.expressions.first.quantified? )
    assert_equal( :repetition, t.expressions.first.quantifier )
    assert_equal( 3, t.expressions.first.min)
    assert_equal( 5, t.expressions.first.max)
    assert_equal( :reluctant, t.expressions.first.quantifier_mode )
    assert_equal( true, t.expressions.first.reluctant? )
  end

  def test_parse_repetitions_min_max_possessive
    t = RP.parse('a{2,4}+bc')

    assert_equal( true, t.expressions.first.quantified? )
    assert_equal( :repetition, t.expressions.first.quantifier )
    assert_equal( 2, t.expressions.first.min)
    assert_equal( 4, t.expressions.first.max)
    assert_equal( :possessive, t.expressions.first.quantifier_mode )
    assert_equal( true, t.expressions.first.possessive? )
  end

  # repetition: min only
  def test_parse_repetitions_min_only_basic
    t = RP.parse('a{2,}bc')

    assert_equal( true, t.expressions.first.quantified? )
    assert_equal( :repetition, t.expressions.first.quantifier )
    assert_equal( 2, t.expressions.first.min)
    assert_equal( -1, t.expressions.first.max)
    assert_equal( :basic, t.expressions.first.quantifier_mode )
  end

  def test_parse_repetitions_min_only_reluctant
    t = RP.parse('a{2,}?bc')

    assert_equal( true, t.expressions.first.quantified? )
    assert_equal( :repetition, t.expressions.first.quantifier )
    assert_equal( 2, t.expressions.first.min)
    assert_equal( -1, t.expressions.first.max)
    assert_equal( :reluctant, t.expressions.first.quantifier_mode )
    assert_equal( true, t.expressions.first.reluctant? )
  end

  def test_parse_repetitions_min_only_possessive
    t = RP.parse('a{3,}+bc')

    assert_equal( true, t.expressions.first.quantified? )
    assert_equal( :repetition, t.expressions.first.quantifier )
    assert_equal( 3, t.expressions.first.min)
    assert_equal( -1, t.expressions.first.max)
    assert_equal( :possessive, t.expressions.first.quantifier_mode )
    assert_equal( true, t.expressions.first.possessive? )
  end

  # repetition: max only
  def test_parse_repetitions_max_only_basic
    t = RP.parse('a{,2}bc')

    assert_equal( true, t.expressions.first.quantified? )
    assert_equal( :repetition, t.expressions.first.quantifier )
    assert_equal( 0, t.expressions.first.min)
    assert_equal( 2, t.expressions.first.max)
    assert_equal( :basic, t.expressions.first.quantifier_mode )
  end

  def test_parse_repetitions_max_only_reluctant
    t = RP.parse('a{,4}?bc')

    assert_equal( true, t.expressions.first.quantified? )
    assert_equal( :repetition, t.expressions.first.quantifier )
    assert_equal( 0, t.expressions.first.min)
    assert_equal( 4, t.expressions.first.max)
    assert_equal( :reluctant, t.expressions.first.quantifier_mode )
    assert_equal( true, t.expressions.first.reluctant? )
  end

  def test_parse_repetitions_max_only_possessive
    t = RP.parse('a{,3}+bc')

    assert_equal( true, t.expressions.first.quantified? )
    assert_equal( :repetition, t.expressions.first.quantifier )
    assert_equal( 0, t.expressions.first.min)
    assert_equal( 3, t.expressions.first.max)
    assert_equal( :possessive, t.expressions.first.quantifier_mode )
    assert_equal( true, t.expressions.first.possessive? )
  end

  # repetition: exact
  def test_parse_repetitions_exact_basic
    t = RP.parse('a{2}bc')

    assert_equal( true, t.expressions.first.quantified? )
    assert_equal( :repetition, t.expressions.first.quantifier )
    assert_equal( 2, t.expressions.first.min)
    assert_equal( 2, t.expressions.first.max)
    assert_equal( :basic, t.expressions.first.quantifier_mode )
  end

  def test_parse_repetitions_exact_reluctant
    t = RP.parse('a{3}?bc')

    assert_equal( true, t.expressions.first.quantified? )
    assert_equal( :repetition, t.expressions.first.quantifier )
    assert_equal( 3, t.expressions.first.min)
    assert_equal( 3, t.expressions.first.max)
    assert_equal( :reluctant, t.expressions.first.quantifier_mode )
    assert_equal( true, t.expressions.first.reluctant? )
  end

  def test_parse_repetitions_exact_possessive
    t = RP.parse('a{3}+bc')

    assert_equal( true, t.expressions.first.quantified? )
    assert_equal( :repetition, t.expressions.first.quantifier )
    assert_equal( 3, t.expressions.first.min)
    assert_equal( 3, t.expressions.first.max)
    assert_equal( :possessive, t.expressions.first.quantifier_mode )
    assert_equal( true, t.expressions.first.possessive? )
  end
end
