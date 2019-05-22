RSpec.shared_examples 'syntax' do |klass, opts|
  opts[:implements].each do |type, tokens|
    tokens.each do |tok|
      it("implements #{tok} #{type}") { expect(klass.implements?(type, tok)).to be true }
    end
  end

  opts[:excludes] && opts[:excludes].each do |type, tokens|
    tokens.each do |tok|
      it("implements #{tok} #{type}") { expect(klass.implements?(type, tok)).to be false }
    end
  end
end

RSpec.shared_examples 'scan' do |pattern, index, type, token, text, ts, te|
  context "given the pattern #{pattern}" do
    let(:pattern) { pattern }
    include_examples 'scan token', index, type, token, text, ts, te
  end
end

RSpec.shared_examples 'scan token' do |index, type, token, text, ts, te|
  it "scans token #{index} as #{token} #{type}" do
    tokens = RS.scan(pattern)
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
    result = RS.scan("\\p{#{text}}")[0]
    expect(result[0..1]).to eq [:property, token]
  end

  it("scans \\P{#{text}} as nonproperty #{token}") do
    result = RS.scan("\\P{#{text}}")[0]
    expect(result[0..1]).to eq [:nonproperty, token]
  end

  it("scans \\p{^#{text}} as nonproperty #{token}") do
    result = RS.scan("\\p{^#{text}}")[0]
    expect(result[0..1]).to eq [:nonproperty, token]
  end

  it("scans double-negated \\P{^#{text}} as property #{token}") do
    result = RS.scan("\\P{^#{text}}")[0]
    expect(result[0..1]).to eq [:property, token]
  end
end

RSpec.shared_examples 'lex' do |pattern, index, type, token, text, ts, te, lvl, set_lvl, cond_lvl|
  context "given the pattern #{pattern}" do
    let(:pattern) { pattern }
    include_examples 'lex token', index, type, token, text, ts, te, lvl, set_lvl, cond_lvl, pattern
  end
end

RSpec.shared_examples 'lex token' do |index, type, token, text, ts, te, lvl, set_lvl, cond_lvl|
  it "lexes token #{index} as #{token} #{type} at #{lvl}, #{set_lvl}, #{cond_lvl}" do
    tokens = RL.lex(pattern)
    struct = tokens.at(index)

    expect(struct.type).to eq type
    expect(struct.token).to eq token
    expect(struct.text).to eq text
    expect(struct.ts).to eq ts
    expect(struct.te).to eq te
    expect(struct.level).to eq lvl
    expect(struct.set_level).to eq set_lvl
    expect(struct.conditional_level).to eq cond_lvl
  end
end

RSpec.shared_examples 'parse' do |pattern, index, type, token, klass|
  it "parses expression #{index} in #{pattern} as #{klass}" do
    root = RP.parse(pattern, '*')
    exp = root.expressions.at(index)

    expect(exp).to be_a(klass)
    expect(exp.type).to eq type
    expect(exp.token).to eq token
  end
end
