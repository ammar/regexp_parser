require 'regexp_parser'
require 'regexp_property_values'

RS = Regexp::Scanner
RL = Regexp::Lexer
RP = Regexp::Parser
RE = Regexp::Expression
T = Regexp::Syntax::Token

include Regexp::Expression

def ruby_version_at_least(version)
  Gem::Version.new(RUBY_VERSION.dup) >= Gem::Version.new(version)
end

RSpec.shared_examples 'scan' do |pattern, index, type, token, text, ts, te|
  it "scans token #{index} in #{pattern} as #{token} #{type}" do
    tokens = RS.scan(pattern)
    result = tokens.at(index)

    expect(result[0]).to eq type
    expect(result[1]).to eq token
    expect(result[2]).to eq text
    expect(result[3]).to eq ts
    expect(result[4]).to eq te

    # verify correctness of ts, te (they are in bytes, so not on multibyte str)
    source = pattern.is_a?(Regexp) ? pattern.source : pattern
    if source.ascii_only? then expect(source[ts...te]).to eq text end
  end
end

RSpec.shared_examples 'scan token' do |index, type, token, text, ts, te|
  it "scans token #{index} as #{token} #{type}" do
    result = tokens.at(index)

    expect(result[0]).to eq type
    expect(result[1]).to eq token
    expect(result[2]).to eq text
    expect(result[3]).to eq ts
    expect(result[4]).to eq te
  end
end

RSpec.shared_examples 'scan property' do |text, token|
  it("scans \\p{#{text}} as property #{token}") do
    tokens = RS.scan("a\\p{#{text}}c")
    result = tokens.at(1)
    expect(result[0]).to eq :property
    expect(result[1]).to eq token
  end

  it("scans \\P{#{text}} as nonproperty #{token}") do
    tokens = RS.scan("a\\P{#{text}}c")
    result = tokens.at(1)
    expect(result[0]).to eq :nonproperty
    expect(result[1]).to eq token
  end

  it("scans \\p{^#{text}} as nonproperty #{token}") do
    tokens = RS.scan("a\\p{^#{text}}c")
    result = tokens.at(1)
    expect(result[0]).to eq :nonproperty
    expect(result[1]).to eq token
  end

  it("scans double-negated \\P{^#{text}} as property #{token}") do
    tokens = RS.scan("a\\P{^#{text}}c")
    result = tokens.at(1)
    expect(result[0]).to eq :property
    expect(result[1]).to eq token
  end
end
