require "test/unit"
require File.expand_path("../../lib/regexp_parser.rb", __FILE__)

RP = Regexp::Parser

class TestRegexpParser < Test::Unit::TestCase

  def test_parse_returns_a_root_expression
    assert_instance_of( RP::Expression::Root, RP.parse('abc'))
  end

  def test_parse_tree_contains_parse_nodes
    tree = RP.parse('abc+[one]{2,3}\b\d\\\C-C')
    assert( tree.expressions.all?{|node| node.kind_of?(RP::Expression::Base)},
          "Not all tree nodes are parse nodes")
  end

  # too much going on here, it's just for development
  def test_parse_node_types
    tree = RP.parse('one{2,3}[def](ghi)+')

    assert( tree.expressions[0].is_a?(RP::Expression::Literal),
          "Not a literal node, but should be")

    assert( tree.expressions[0].quantified?, "Not quanfified, but should be")

    assert( tree.expressions[1].is_a?(RP::Expression::CharacterSet),
          "Not a caracter set, but it should be")

    assert_equal( false, tree.expressions[1].quantified? )

    assert( tree.expressions[2].is_a?(RP::Expression::Group),
          "Not a group, but should be")
  end
end
