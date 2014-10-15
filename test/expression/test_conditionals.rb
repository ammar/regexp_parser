require File.expand_path("../../helpers", __FILE__)

class ExpressionConditionals < Test::Unit::TestCase

  def test_expression_conditional_level
    regexp = /^a(b(?(1)c|(?(2)d|(?(3)e|f)))g)$/
    root = RP.parse(regexp)

    %w{^ a (b(?(1)c|(?(2)d|(?(3)e|f)))g) $}.each_with_index do |t, i|
      assert_equal( 0, root[i].conditional_level )
      assert_equal( t, root[i].to_s )
    end

    assert_equal( 'b',    root[2][0].text )
    assert_equal( 0,      root[2][0].conditional_level )

    assert_equal( '(1)',  root[2][1][0].text )
    assert_equal( 1,      root[2][1][0].conditional_level )

    # Sequence
    assert_equal( 'c',    root[2][1][1].text )
    assert_equal( 1,      root[2][1][1].conditional_level )

    # Literal
    assert_equal( 'c',    root[2][1][1][0].text )
    assert_equal( 1,      root[2][1][1][0].conditional_level )

    assert_equal( '(?',   root[2][1][2][0].text )
    assert_equal( 1,      root[2][1][2][0].conditional_level )

    # Sequence
    assert_equal( 'd',    root[2][1][2][0][1].text )
    assert_equal( 2,      root[2][1][2][0][1].conditional_level )

    # Literal
    assert_equal( 'd',    root[2][1][2][0][1][0].text )
    assert_equal( 2,      root[2][1][2][0][1][0].conditional_level )

    assert_equal( '(?',   root[2][1][2][0][2][0].text )
    assert_equal( 2,      root[2][1][2][0][2][0].conditional_level )

    # Sequence
    assert_equal( 'f',    root[2][1][2][0][2][0][2].text )
    assert_equal( 3,      root[2][1][2][0][2][0][2].conditional_level )

    # Literal
    assert_equal( 'f',    root[2][1][2][0][2][0][2][0].text )
    assert_equal( 3,      root[2][1][2][0][2][0][2][0].conditional_level )
  end

end
