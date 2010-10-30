require File.expand_path("../../helpers", __FILE__)

class TestRegexpParserSets < Test::Unit::TestCase

  def test_parse_set_basic
    root = RP.parse('[a-c]+', :any)

    assert_equal( true, root.expressions[0].is_a?(Regexp::Expression::CharacterSet) )
    assert_equal( true, root.expressions[0].include?('b') )
  end

  def test_parse_set_posix_class
    root = RP.parse('[[:alpha:][:ascii:]]+', 'ruby/1.9')
    #puts "root: #{root.inspect}"
    pr root

    assert_equal( true, root.expressions[0].is_a?(Regexp::Expression::CharacterSet) )
    assert_equal( true, root.expressions[0].include?('h') )
    assert_equal( true, root.expressions[0].include?("\x48") )
  end

end
