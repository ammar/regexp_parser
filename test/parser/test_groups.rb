require File.expand_path("../../helpers", __FILE__)

class TestParserGroups < Test::Unit::TestCase

  def test_parse_options_xi
    t = RP.parse(/(?xi-m:a(?m-ix:b))/)

    assert_equal( false, t.expressions.first.m? )
    assert_equal( true,  t.expressions.first.i? )
    assert_equal( true,  t.expressions.first.x? )
  end

  def test_parse_options_xm
    t = RP.parse(/(?xm-i:a(?m-ix:b))/)

    assert_equal( true,  t.expressions.first.m? )
    assert_equal( false, t.expressions.first.i? )
    assert_equal( true,  t.expressions.first.x? )
  end

  def test_parse_options_im
    t = RP.parse(/(?mi-x:a(?m-ix:b))/)

    assert_equal( true,  t.expressions.first.m? )
    assert_equal( true,  t.expressions.first.i? )
    assert_equal( false, t.expressions.first.x? )
  end

  def test_parse_lookahead
    t = RP.parse('(?=abc)(?!def)')

    assert( t.expressions[0].is_a?(Assertion::Lookahead),
           "Expected lookahead, but got #{t.expressions[0].class.name}")

    assert( t.expressions[1].is_a?(Assertion::NegativeLookahead),
           "Expected negative lookahead, but got #{t.expressions[0].class.name}")
  end

  def test_parse_lookbehind
    t = RP.parse('(?<=abc)(?<!def)')

    assert( t.expressions[0].is_a?(Assertion::Lookbehind),
           "Expected lookbehind, but got #{t.expressions[0].class.name}")

    assert( t.expressions[1].is_a?(Assertion::NegativeLookbehind),
           "Expected negative lookbehind, but got #{t.expressions[0].class.name}")
  end

  def test_parse_comment
    t = RP.parse('a(?# is for apple)b(?# for boy)c(?# cat)')

    [1,3,5].each do |i|
      assert( t.expressions[i].is_a?(Group::Comment),
             "Expected comment, but got #{t.expressions[i].class.name}")

      assert_equal( :group,   t.expressions[i].type )
      assert_equal( :comment, t.expressions[i].token )
    end
  end

end
