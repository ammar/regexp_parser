require File.expand_path("../../helpers", __FILE__)

class TestRegexpParserGroups < Test::Unit::TestCase

  def test_parse_group
    #t = RP.parse('(?ix-mx:a(?<name>b*(?:c*(?#d+))))')
    t = RP.parse(/(?xi-m:a(?m-ix:b))/)
    #puts " *** ROOT: #{t.inspect}"

    assert_equal( false, t.expressions.first.m? )
    assert_equal( true, t.expressions.first.i? )
    assert_equal( true, t.expressions.first.x? )
  end

end
