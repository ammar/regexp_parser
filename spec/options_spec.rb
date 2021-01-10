require 'spec_helper'

RSpec.describe(Regexp::Options) do
  it 'can be initialized without an argument' do
    expect(Regexp::Options.new).to eq({})
  end

  it 'takes a Regexp, extracting its options into a Hash' do
    expect(Regexp::Options.new(/foo/)).to eq({})
    expect(Regexp::Options.new(/foo/m)).to eq({ m: true })
    expect(Regexp::Options.new(/foo/mx)).to eq({ m: true, x: true })
  end

  it 'takes a regopt Integer' do
    expect(Regexp::Options.new(0)).to eq({})
    expect(Regexp::Options.new(Regexp::MULTILINE)).to eq({ m: true })
    expect(Regexp::Options.new(Regexp::MULTILINE | Regexp::EXTENDED)).to eq({ m: true, x: true })
  end

  it 'takes a regopt String' do
    expect(Regexp::Options.new('')).to eq({})
    expect(Regexp::Options.new('m')).to eq({ m: true })
    expect(Regexp::Options.new('mx')).to eq({ m: true, x: true })
  end

  it 'takes a regopt Array' do
    expect(Regexp::Options.new([])).to eq({})
    expect(Regexp::Options.new([:m])).to eq({ m: true })
    expect(Regexp::Options.new([:m, :x])).to eq({ m: true, x: true })
  end

  it 'raises if initialized with nil or unsupported Objects' do
    expect { Regexp::Options.new(nil) }.to raise_error(Regexp::Options::Error)
    expect { Regexp::Options.new(Object.new) }.to raise_error(Regexp::Options::Error)
  end

  it 'raises if initialized with unknown options' do
    expect { Regexp::Options.new('y') }.to raise_error(Regexp::Options::Error)
    expect { Regexp::Options.new('xy') }.to raise_error(Regexp::Options::Error)
  end

  it 'responds to Options::Shorthands' do
    expect(Regexp::Options.new('i')).to be_case_insensitive
    expect(Regexp::Options.new('i').i?).to eq true
    expect(Regexp::Options.new('x')).not_to be_case_insensitive
    expect(Regexp::Options.new('x').i?).to eq false
  end

  it 'can be cast #to_a' do
    expect(Regexp::Options.new.to_a).to eq []
    expect(Regexp::Options.new('mx').to_a).to eq [:m, :x]
    expect(Regexp::Options.new('d').to_a).to eq [:d]
  end

  it 'can be cast #to_i' do
    expect(Regexp::Options.new.to_i).to eq 0
    expect(Regexp::Options.new('mx').to_i).to eq Regexp::MULTILINE | Regexp::EXTENDED
    expect(Regexp::Options.new('d').to_i).to eq 0 # non-root option has no int value
  end

  it 'can be cast #to_s' do
    expect(Regexp::Options.new.to_s).to eq ''
    expect(Regexp::Options.new('mx').to_s).to eq 'mx'
    expect(Regexp::Options.new('d').to_s).to eq 'd'
  end
end
