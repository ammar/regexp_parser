require File.expand_path("../../helpers", __FILE__)

class ParserExpression < Test::Unit::TestCase

  def test_parse_expression_to_s_quantified_alternation
    root = RP.parse('(abc*?d+)+|(ghi++j?){3,6}')
    assert_equal( "(abc*?d+)+|(ghi++j?){3,6}", root.to_s )
  end

  def test_parse_expression_to_s_quantified_sets
    root = RP.parse('[abc]+|[def]{3,6}')
    assert_equal( "[abc]+|[def]{3,6}", root.to_s )
  end

end
