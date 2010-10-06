require "test/unit"
require File.expand_path("../../lib/regexp.rb", __FILE__)

class TestRegexpParser < Test::Unit::TestCase

  def test_parse_returns_a_parse_tree
    assert_instance_of( Regexp::Parser::Tree, Regexp::Parser.parse('abc'))
  end

  def test_parse_tree_contains_parse_nodes
    tree = Regexp::Parser.parse('abc+[one]{2,3}\b\d\\\C-C')
    puts "nodes: #{tree.nodes.inspect}"
    assert( tree.nodes.all?{|node| node.kind_of?(Regexp::Parser::Node::Base)},
          "Not all tree nodes are parse nodes")
  end

  # too much going on here, it's just for development
  def test_parse_node_types
    tree = Regexp::Parser.parse('one{2,3}[def](ghi)+')

    assert( tree.nodes[0].is_a?(Regexp::Parser::Node::Literal),
          "Not a literal node, but should be")

    assert( tree.nodes[0].quantified?, "Not quanfified, but should be")

    assert( tree.nodes[1].is_a?(Regexp::Parser::Node::CharacterSet),
          "Not a caracter set, but it should be")

    assert_equal( false, tree.nodes[1].quantified? )

    assert( tree.nodes[2].is_a?(Regexp::Parser::Node::Group),
          "Not a group, but should be")
  end
end
