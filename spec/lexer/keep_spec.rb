require 'spec_helper'

RSpec.describe('Keep lexing') do
  specify('lex keep token') do
    regexp = /ab\Kcd/
    tokens = RL.lex(regexp)

    expect(tokens[1].type).to eq :keep
    expect(tokens[1].token).to eq :mark
  end

  specify('lex keep nested') do
    regexp = /(a\Kb)|(c\\\Kd)ef/
    tokens = RL.lex(regexp)

    expect(tokens[2].type).to eq :keep
    expect(tokens[2].token).to eq :mark

    expect(tokens[9].type).to eq :keep
    expect(tokens[9].token).to eq :mark
  end
end
