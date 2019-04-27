require 'spec_helper'

RSpec.describe('PosixClasse parsing') do
  specify('parse posix class') do
    root = RP.parse('[[:word:]]')
    exp = root[0][0]

    expect(exp).to be_instance_of(PosixClass)
    expect(exp.type).to eq :posixclass
    expect(exp.token).to eq :word
    expect(exp.name).to eq 'word'
    expect(exp.text).to eq '[:word:]'
    expect(exp).not_to be_negative
  end

  specify('parse negative posix class') do
    root = RP.parse('[[:^word:]]')
    exp = root[0][0]

    expect(exp).to be_instance_of(PosixClass)
    expect(exp.type).to eq :nonposixclass
    expect(exp.token).to eq :word
    expect(exp.name).to eq 'word'
    expect(exp.text).to eq '[:^word:]'
    expect(exp).to be_negative
  end
end
