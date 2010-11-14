require File.expand_path("../../helpers", __FILE__)

class TestParserSets < Test::Unit::TestCase

  def test_parse_set_basic
    exp = RP.parse('[a-c]+', :any).expressions[0]

    assert_equal( true, exp.is_a?(CharacterSet) )
    assert_equal( true, exp.include?('b') )

    assert_equal( true, exp.quantified? )
    assert_equal( 1,  exp.quantifier.min )
    assert_equal( -1, exp.quantifier.max )
  end

  def test_parse_set_posix_class
    exp = RP.parse('[[:alpha:][:ascii:]]+', 'ruby/1.9').expressions[0]

    assert_equal( true, exp.is_a?(CharacterSet) )
    assert_equal( true, exp.include?('h') )
    assert_equal( true, exp.include?("\x48") )
  end

  def test_parse_set_members
    exp = RP.parse('[ac-eh]', :any)[0]

    assert_equal( true,  exp.include?('d') )
    assert_equal( false, exp.include?(']') )
  end

  # TODO: complete sub-set parsing
 #def test_parse_set_nesting
 #  exp = RP.parse('[a[b[c]]]', 'ruby/1.9').expressions[0]

 #  assert_equal( true, exp.is_a?(CharacterSet) )
 #  assert_equal( true, exp.include?('a') )
 #  assert_equal( true, exp.include?('b') )
 #  assert_equal( true, exp.include?('c') )
 #end

end
