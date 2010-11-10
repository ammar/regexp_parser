require File.expand_path("../../helpers", __FILE__)

class ParserExpression < Test::Unit::TestCase

  def setup
    @root = RP.parse('(abcd+)+|(ghij?)?')
  end

  def test_parse_expression_to_s
    assert_equal( "(abcd+)+|(ghij?)?",   @root.to_s )
  end

end
