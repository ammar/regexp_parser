# frozen_string_literal: true

require 'spec_helper'

RSpec.describe('Expression::Base#to_h') do
  include_examples 'parse', /abc/, [] => [Root, to_h: {
    token: :root,
    type: :expression,
    text: 'abc',
    starts_at: 0,
    length: 3,
    quantifier: nil,
    options: {},
    level: 0,
    set_level: 0,
    conditional_level: 0,
    expressions: [
      {
        token: :literal,
        type: :literal,
        text: 'abc',
        starts_at: 0,
        length: 3,
        quantifier: nil,
        options: {},
        level: 0,
        set_level: 0,
        conditional_level: 0
      }
    ]
  }]

  include_examples 'parse', /a{2,4}/, [0, :q] => [Quantifier, to_h: {
    max: 4,
    min: 2,
    mode: :greedy,
    text: '{2,4}',
    token: :interval,
  }]

  specify('Conditional#to_h') do
    root = RP.parse('(?<A>a)(?(<A>)b|c)')
    expect { root.to_h }.not_to(raise_error)
  end
end
