require File.expand_path("../../helpers", __FILE__)

class ParserAlternation < Test::Unit::TestCase

  # TODO: these tests pass, but they show how hard and messy the tree is
  # to navigate

  def setup
    @root = RP.parse('(ab??|cd*|ef+)*|(gh|ij|kl)?')
  end

  def test_parse_alternation_root
    e = @root.expressions[0]
    assert_equal( true,   e.is_a?(Alternation) )
  end

  def test_parse_alternation_alts
    alts = @root.expressions[0].alternatives

    assert_equal( true,   alts[0].is_a?(Sequence) )
    assert_equal( true,   alts[1].is_a?(Sequence) )

    assert_equal( true,   alts[0][0].is_a?(Group::Capture) )
    assert_equal( true,   alts[1][0].is_a?(Group::Capture) )

    assert_equal( 2,      alts.length )
  end

  def test_parse_alternation_nested
    e = @root[0].alternatives[0][0][0]

    assert_equal( true,   e.is_a?(Alternation) )
  end

  def test_parse_alternation_nested_sequence
    alts    = @root.expressions[0][0]
    nested  = alts.expressions[0][0][0]

    assert_equal( true,   nested.is_a?(Sequence) )

    assert_equal( true,   nested.expressions[0].is_a?(Literal) )
    assert_equal( true,   nested.expressions[1].is_a?(Literal) )
    assert_equal( 2,      nested.expressions.length )
  end

end
