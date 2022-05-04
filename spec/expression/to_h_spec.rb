require 'spec_helper'

RSpec.describe('Expression::Base#to_h') do
  specify('Root#to_h') do
    root = RP.parse('abc')
    expect(root.to_h).to eq(
      token: :root,
      type: :expression,
      text: 'abc',
      starts_at: 0,
      length: 3,
      quantifier: nil,
      options: {},
      level: nil,
      set_level: nil,
      conditional_level: nil,
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
    )
  end

  specify('Quantifier#to_h') do
    root = RP.parse('a{2,4}')
    exp = root.expressions.at(0)
    expect(exp.quantifier.to_h).to eq(
      max: 4,
      min: 2,
      mode: :greedy,
      text: '{2,4}',
      token: :interval,
    )
  end

  specify('Conditional#to_h') do
    root = RP.parse('(?<A>a)(?(<A>)b|c)')
    expect { root.to_h }.not_to(raise_error)
  end
end
