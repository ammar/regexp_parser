# frozen_string_literal: true

require 'spec_helper'

RSpec.describe(Regexp::Expression::Subexpression) do
  # check #ts, #te
  include_examples 'parse', /abcd|ghij|klmn|pqur/,
    [0]    => [Alternation, ts: 0,  te: 19],
    [0, 0] => [Alternative, ts: 0,  te: 4],
    [0, 1] => [Alternative, ts: 5,  te: 9],
    [0, 2] => [Alternative, ts: 10, te: 14],
    [0, 3] => [Alternative, ts: 15, te: 19]

  # check #nesting_level
  include_examples 'parse', /a(b(\d|[ef-g[h]]))/,
    [0]                   => [Literal,              to_s: 'a',            nesting_level: 1],
    [1, 0]                => [Literal,              to_s: 'b',            nesting_level: 2],
    [1, 1, 0]             => [Alternation,          to_s: '\d|[ef-g[h]]', nesting_level: 3],
    [1, 1, 0, 0]          => [Alternative,          to_s: '\d',           nesting_level: 4],
    [1, 1, 0, 0, 0]       => [CharacterType::Digit, to_s: '\d',           nesting_level: 5],
    [1, 1, 0, 1]          => [Alternative,          to_s: '[ef-g[h]]',    nesting_level: 4],
    [1, 1, 0, 1, 0]       => [CharacterSet,         to_s: '[ef-g[h]]',    nesting_level: 5],
    [1, 1, 0, 1, 0, 0]    => [Literal,              to_s: 'e',            nesting_level: 6],
    [1, 1, 0, 1, 0, 1]    => [CharacterSet::Range,  to_s: 'f-g',          nesting_level: 6],
    [1, 1, 0, 1, 0, 1, 0] => [Literal,              to_s: 'f',            nesting_level: 7],
    [1, 1, 0, 1, 0, 2, 0] => [Literal,              to_s: 'h',            nesting_level: 7]

  specify('#dig') do
    root = RP.parse(/(((a)))/)

    expect(root.dig(0).to_s).to eq '(((a)))'
    expect(root.dig(0, 0, 0, 0).to_s).to eq 'a'
    expect(root.dig(0, 0, 0, 0, 0)).to be_nil
    expect(root.dig(3, 7)).to be_nil
  end
end
