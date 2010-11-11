require File.expand_path("../../helpers", __FILE__)

class ParserExpression < Test::Unit::TestCase

  def test_parse_expression_to_s_quantified_alternation
    pattern = '(abc*?d+)+|(ghi++j?){3,6}'
    assert_equal( pattern, RP.parse(pattern).to_s )
  end

  def test_parse_expression_to_s_quantified_sets
    pattern = '[abc]+|[^def]{3,6}'
    assert_equal( pattern, RP.parse(pattern).to_s )
  end

  def test_parse_expression_to_s_property_sets
    pattern = '[\a\b\p{Lu}\P{Z}\c\d]+'
    assert_equal( pattern, RP.parse(pattern).to_s )
  end

end
