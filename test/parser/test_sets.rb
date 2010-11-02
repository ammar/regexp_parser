require File.expand_path("../../helpers", __FILE__)

class TestRegexpParserSets < Test::Unit::TestCase

  def test_parse_set_basic
    exp = RP.parse('[a-c]+', :any).expressions[0]

    assert_equal( true, exp.is_a?(Regexp::Expression::CharacterSet) )
    assert_equal( true, exp.include?('b') )

    assert_equal( true, exp.quantified? )
    assert_equal( 1,  exp.quantifier.min )
    assert_equal( -1, exp.quantifier.max )
  end

  def test_parse_set_posix_class
    exp = RP.parse('[[:alpha:][:ascii:]]+', 'ruby/1.9').expressions[0]

    assert_equal( true, exp.is_a?(Regexp::Expression::CharacterSet) )
    assert_equal( true, exp.include?('h') )
    assert_equal( true, exp.include?("\x48") )
  end

end
