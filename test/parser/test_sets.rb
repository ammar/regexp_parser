require File.expand_path("../../helpers", __FILE__)

class TestParserSets < Test::Unit::TestCase

  def test_parse_set_basic
    exp = RP.parse('[a-c]+', :any).expressions[0]

    assert_equal( true, exp.is_a?(CharacterSet) )
    assert_equal( true, exp.include?('a-c') )

    assert_equal( true, exp.quantified? )
    assert_equal( 1,  exp.quantifier.min )
    assert_equal( -1, exp.quantifier.max )
  end

  def test_parse_set_posix_class
    exp = RP.parse('[[:digit:][:lower:]]+', 'ruby/1.9').expressions[0]

    assert_equal( true,  exp.is_a?(CharacterSet) )

    assert_equal( true,  exp.include?('[:digit:]') )
    assert_equal( true,  exp.include?('[:lower:]') )

    assert_equal( true,  exp.matches?("6") )
    assert_equal( true,  exp.matches?("v") )

    assert_equal( false, exp.matches?("\x48") )
  end

  def test_parse_set_members
    exp = RP.parse('[ac-eh]', :any)[0]

    assert_equal( true,  exp.include?('a') )
    assert_equal( true,  exp.include?('c-e') )
    assert_equal( true,  exp.include?('h') )
    assert_equal( false, exp.include?(']') )
  end

  # TODO: complete sub-set parsing
 #def test_parse_set_nesting
 #  root = RP.parse('[a[b[c]]]', 'ruby/1.9')
 #  pr root

 #  exp = root[0]
 #  puts "SET: #{exp.inspect}"

 #  assert_equal( true, exp.is_a?(CharacterSet) )
 #  assert_equal( true, exp.include?('a') )
 #  assert_equal( true, exp.include?('b') )
 #  assert_equal( true, exp.include?('c') )
 #end

end
