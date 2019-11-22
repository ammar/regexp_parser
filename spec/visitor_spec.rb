require 'spec_helper'
require 'regexp_parser/visitor'

RSpec::Matchers.define(:have_visited) do |expected|
  match do |actual|
    actual.visited == Array(expected)
  end
end

class TestVisitor < Regexp::Visitor
  attr_reader :visited

  def initialize
    @visited = []
  end

  def visit_literal(node)
    visited << "literal: #{node.to_s}"
    super
  end

  def visit_group_capture(node)
    visited << "group: #{node.to_s}"
    super
  end

  def visit_character_set(node)
    visited << "character set: #{node.to_s}"
    super
  end

  def visit_anchor_beginning_of_string(node)
    visited << "anchor: #{node.to_s}"
    super
  end

  def visit_anchor_end_of_string(node)
    visited << "anchor: #{node.to_s}"
    super
  end
end

RSpec.describe(Regexp::Visitor) do
  let(:visitor) { TestVisitor.new }

  it 'visits a simple literal' do
    visitor.visit(RP.parse('abc'))
    expect(visitor).to have_visited('literal: abc')
  end

  it 'visits a group and the literal inside it' do
    visitor.visit(RP.parse('(abc)'))
    expect(visitor).to have_visited([
      'group: (abc)',
      'literal: abc'
    ])
  end

  it 'visits a character set inside a group' do
    visitor.visit(RP.parse('(a[bc]d)'))
    expect(visitor).to have_visited([
      'group: (a[bc]d)',
      'literal: a',
      'character set: [bc]',
      'literal: b',
      'literal: c',
      'literal: d',
    ])
  end

  it 'visits anchors' do
    visitor.visit(RP.parse('\Aabc\z'))
    expect(visitor).to have_visited([
      'anchor: \A',
      'literal: abc',
      'anchor: \z'
    ])
  end
end
