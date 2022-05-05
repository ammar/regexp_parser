require 'spec_helper'

RSpec.describe(Regexp::Expression::Conditional) do
  specify('Conditional#condition, #branches') do
    conditional = RP.parse(/(?<A>a)(?(<A>)T|F)/)[1]
    expect(conditional.condition).to eq conditional[0]
    expect(conditional.branches).to eq conditional[1..2]
  end

  specify('Condition#referenced_expression') do
    exp = RP.parse(/(?<A>a)(?(<A>)T|F)/)[1].condition
    expect(exp.referenced_expression.to_s).to eq '(?<A>a)'
    exp = RP.parse(/(a)(?(1)T|F)/)[1].condition
    expect(exp.referenced_expression.to_s).to eq '(a)'
  end

  specify('parse conditional excessive branches') do
    regexp = '(?<A>a)(?(<A>)T|F|X)'

    expect { RP.parse(regexp) }.to raise_error(Conditional::TooManyBranches)
  end
end
