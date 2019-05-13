require 'spec_helper'

RSpec.describe('Keep scanning') do
  specify('scan keep token') do
    tokens = RS.scan(/ab\Kcd/)
    result = tokens.at(1)

    expect(result[0]).to eq :keep
    expect(result[1]).to eq :mark
    expect(result[2]).to eq '\\K'
    expect(result[3]).to eq 2
    expect(result[4]).to eq 4
  end

  specify('scan keep nested') do
    tokens = RS.scan(/(a\Kb)|(c\\\Kd)ef/)

    first = tokens.at(2)
    second = tokens.at(9)

    expect(first[0]).to eq :keep
    expect(first[1]).to eq :mark
    expect(first[2]).to eq '\\K'
    expect(first[3]).to eq 2
    expect(first[4]).to eq 4

    expect(second[0]).to eq :keep
    expect(second[1]).to eq :mark
    expect(second[2]).to eq '\\K'
    expect(second[3]).to eq 11
    expect(second[4]).to eq 13
  end
end
