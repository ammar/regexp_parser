require File.expand_path("../helpers", __FILE__)

class TestRegexpParser < Test::Unit::TestCase

  def test_parse_returns_a_root_expression
    assert_instance_of( RP::Expression::Root, RP.parse('abc'))
  end

  def test_parse_root_contains_expressions
    root = RP.parse(/^a.c+[^one]{2,3}\b\d\\\C-C$/)

    assert( root.expressions.all?{|exp| exp.kind_of?(RP::Expression::Base)},
          "Not all tree nodes are parse nodes")
  end

  # too much going on here, it's just for development
  def test_parse_node_types
    root = RP.parse('^(one){2,3}([^d\]efm-qz\,\-]*)(ghi)+$')

    assert( root.expressions[1].expressions[0].is_a?(RP::Expression::Literal),
          "Not a literal node, but should be")

    assert( root.expressions[1].quantified?, "Not quanfified, but should be")

    assert( root.expressions[2].expressions[0].is_a?(RP::Expression::CharacterSet),
          "Not a caracter set, but it should be")

    assert_equal( false, root.expressions[2].quantified? )

    assert( root.expressions[3].is_a?(RP::Expression::Group),
          "Not a group, but should be")

    assert_equal( true, root.expressions[3].quantified? )
  end

end
