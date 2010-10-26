require File.expand_path("../../helpers", __FILE__)

class ParserAlternation < Test::Unit::TestCase

  def setup
    @root = RP.parse('(ab??|cd*+|ef+)*|(gh|ij|kl)?')
  end

  def test_parse_alternation_root
    e = @root.expressions[0]
    assert_equal( true,   e.is_a?(RP::Expression::Alternation) )
  end

  def test_parse_alternation_alts
    alts = @root.expressions[0].alternatives

    assert_equal( true,   alts[0].is_a?(RP::Expression::Group) )
    assert_equal( true,   alts[1].is_a?(RP::Expression::Group) )
    assert_equal( 2,      alts.length )
  end

  def test_parse_alternation_nested
    e = @root.expressions[0].alternatives[0].expressions[0]

    assert_equal( true,   e.is_a?(RP::Expression::Alternation) )
  end

  def test_parse_alternation_nested_sequence
    alts = @root.expressions[0].alternatives[0].
           expressions[0].alternatives[0]

    assert_equal( true,   alts.is_a?(RP::Expression::Sequence) )

    assert_equal( true,   alts.expressions[0].is_a?(RP::Expression::Literal) )
    assert_equal( true,   alts.expressions[1].is_a?(RP::Expression::Literal) )
    assert_equal( 2,      alts.expressions.length )
  end

end
