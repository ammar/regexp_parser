require File.expand_path("../../helpers", __FILE__)

class TestParserGroups < Test::Unit::TestCase

  def test_parse_root_options_mi
    t = RP.parse((/[abc]/mi).to_s, 'ruby/1.8')

    assert_equal( true,  t.m? )
    assert_equal( true,  t.i? )
    assert_equal( false, t.x? )
  end

  def test_parse_nested_options_m
    t = RP.parse('(?xi-m:a(?m-ix:b))', 'ruby/1.8')

    assert_equal( true,  t.expressions[0].expressions[1].m? )
    assert_equal( false, t.expressions[0].expressions[1].i? )
    assert_equal( false, t.expressions[0].expressions[1].x? )
  end

  def test_parse_nested_options_xm
    t = RP.parse(/(?i-xm:a(?mx-i:b))/, 'ruby/1.8')

    assert_equal( true,  t.expressions[0].expressions[1].m? )
    assert_equal( false, t.expressions[0].expressions[1].i? )
    assert_equal( true,  t.expressions[0].expressions[1].x? )
  end

  def test_parse_nested_options_im
    t = RP.parse(/(?x-mi:a(?mi-x:b))/, 'ruby/1.8')

    assert_equal( true,  t.expressions[0].expressions[1].m? )
    assert_equal( true,  t.expressions[0].expressions[1].i? )
    assert_equal( false, t.expressions[0].expressions[1].x? )
  end

  def test_parse_lookahead
    t = RP.parse('(?=abc)(?!def)', 'ruby/1.8')

    assert( t.expressions[0].is_a?(Assertion::Lookahead),
           "Expected lookahead, but got #{t.expressions[0].class.name}")

    assert( t.expressions[1].is_a?(Assertion::NegativeLookahead),
           "Expected negative lookahead, but got #{t.expressions[0].class.name}")
  end

  def test_parse_lookbehind
    t = RP.parse('(?<=abc)(?<!def)', 'ruby/1.9')

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
