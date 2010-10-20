require File.expand_path("../../helpers", __FILE__)

class TestRegexpParser < Test::Unit::TestCase

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
