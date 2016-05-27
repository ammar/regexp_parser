require File.expand_path("../../helpers", __FILE__)

class ParserAlternation < Test::Unit::TestCase

  def setup
    @root = RP.parse('(ab??|cd*|ef+)*|(gh|ij|kl)?')
  end

  def test_parse_alternation_root
    e = @root.expressions[0]
    assert_equal true,   e.is_a?(Alternation)
  end

  def test_parse_alternation_alts
    alts = @root.expressions[0].alternatives

    assert_equal true,   alts[0].is_a?(Alternative)
    assert_equal true,   alts[1].is_a?(Alternative)

    assert_equal true,   alts[0][0].is_a?(Group::Capture)
    assert_equal true,   alts[1][0].is_a?(Group::Capture)

    assert_equal 2,      alts.length
  end

  def test_parse_alternation_nested
    e = @root[0].alternatives[0][0][0]

    assert_equal true, e.is_a?(Alternation)
  end

  def test_parse_alternation_nested_sequence
    alts    = @root.expressions[0][0]
    nested  = alts.expressions[0][0][0]

    assert_equal true,   nested.is_a?(Alternative)

    assert_equal true,   nested.expressions[0].is_a?(Literal)
    assert_equal true,   nested.expressions[1].is_a?(Literal)
    assert_equal 2,      nested.expressions.length
  end

  def test_parse_alternation_nested_groups
    root = RP.parse('(i|ey|([ougfd]+)|(ney))')

    alts = root.expressions[0][0].alternatives
    assert_equal 4,  alts.length
  end

  def test_parse_alternation_grouped_alts
    root = RP.parse('ca((n)|(t)|(ll)|(b))')

    alts = root.expressions[1][0].alternatives

    assert_equal 4, alts.length

    assert_equal true, alts[0].is_a?(Alternative)
    assert_equal true, alts[1].is_a?(Alternative)
    assert_equal true, alts[2].is_a?(Alternative)
    assert_equal true, alts[3].is_a?(Alternative)
  end

  def test_parse_alternation_nested_grouped_alts
    root = RP.parse('ca((n|t)|(ll|b))')

    alts = root.expressions[1][0].alternatives

    assert_equal 2, alts.length

    assert_equal true, alts[0].is_a?(Alternative)
    assert_equal true, alts[1].is_a?(Alternative)

    subalts = root.expressions[1][0][0][0][0].alternatives

    assert_equal 2, alts.length

    assert_equal true, subalts[0].is_a?(Alternative)
    assert_equal true, subalts[1].is_a?(Alternative)
  end

  def test_parse_alternation_continues_after_nesting
    root = RP.parse(/a|(b)c/)

    seq = root.expressions[0][1].expressions

    assert_equal 2, seq.length

    assert_equal true, seq[0].is_a?(Group::Capture)
    assert_equal true, seq[1].is_a?(Literal)
  end

end
