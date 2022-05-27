require 'spec_helper'

RSpec.describe('Expression::Base#options') do
  it 'returns a hash of options/flags that affect the expression' do
    exp = RP.parse(/a/ix)[0]
    expect(exp).to be_a Literal
    expect(exp.options).to eq(i: true, x: true)
  end

  it 'includes options that are locally enabled via special groups' do
    exp = RP.parse(/(?x)(?m:a)/i)[1][0]
    expect(exp).to be_a Literal
    expect(exp.options).to eq(i: true, m: true, x: true)
  end

  it 'excludes locally disabled options' do
    exp = RP.parse(/(?x)(?-im:a)/i)[1][0]
    expect(exp).to be_a Literal
    expect(exp.options).to eq(x: true)
  end

  it 'gives correct precedence to negative options' do
    # Negative options have precedence. E.g. /(?i-i)a/ is case-sensitive.
    regexp = /(?i-i:a)/
    expect(regexp).to match 'a'
    expect(regexp).not_to match 'A'

    exp = RP.parse(regexp)[0][0]
    expect(exp).to be_a Literal
    expect(exp.options).to eq({})
  end

  it 'correctly handles multiple negative option parts' do
    regexp = /(?--m--mx--) . /mx
    expect(regexp).to match ' . '
    expect(regexp).not_to match '.'
    expect(regexp).not_to match "\n"

    exp = RP.parse(regexp)[2]
    expect(exp.options).to eq({})
  end

  it 'gives correct precedence when encountering multiple encoding flags' do
    # Any encoding flag overrides all previous encoding flags. If there are
    # multiple encoding flags in an options string, the last one wins.
    # E.g. /(?dau)\w/ matches UTF8 chars but /(?dua)\w/ only ASCII chars.
    regexp1 = /(?dau)\w/
    regexp2 = /(?dua)\w/
    expect(regexp1).to match 'ü'
    expect(regexp2).not_to match 'ü'

    exp1 = RP.parse(regexp1)[1]
    exp2 = RP.parse(regexp2)[1]
    expect(exp1.options).to eq(u: true)
    expect(exp2.options).to eq(a: true)
  end

  it 'is accessible via shortcuts' do
    exp = Root.construct

    expect { exp.options[:i] = true }
      .to  change { exp.i? }.from(false).to(true)
      .and change { exp.ignore_case? }.from(false).to(true)
      .and change { exp.case_insensitive? }.from(false).to(true)

    expect { exp.options[:m] = true }
      .to  change { exp.m? }.from(false).to(true)
      .and change { exp.multiline? }.from(false).to(true)

    expect { exp.options[:x] = true }
      .to  change { exp.x? }.from(false).to(true)
      .and change { exp.extended? }.from(false).to(true)
      .and change { exp.free_spacing? }.from(false).to(true)

    expect { exp.options[:a] = true }
      .to  change { exp.a? }.from(false).to(true)
      .and change { exp.ascii_classes? }.from(false).to(true)

    expect { exp.options[:d] = true }
      .to  change { exp.d? }.from(false).to(true)
      .and change { exp.default_classes? }.from(false).to(true)

    expect { exp.options[:u] = true }
      .to  change { exp.u? }.from(false).to(true)
      .and change { exp.unicode_classes? }.from(false).to(true)
  end

  include_examples 'parse', //i,             []           => [:root,         i?: true, x?: false]
  include_examples 'parse', /a/i,            [0]          => [:literal,      i?: true, x?: false]
  include_examples 'parse', /\A/i,           [0]          => [:bos,          i?: true, x?: false]
  include_examples 'parse', /\d/i,           [0]          => [:digit,        i?: true, x?: false]
  include_examples 'parse', /\n/i,           [0]          => [:newline,      i?: true, x?: false]
  include_examples 'parse', /\K/i,           [0]          => [:mark,         i?: true, x?: false]
  include_examples 'parse', /./i,            [0]          => [:dot,          i?: true, x?: false]
  include_examples 'parse', /(a)/i,          [0]          => [:capture,      i?: true, x?: false]
  include_examples 'parse', /(a)/i,          [0, 0]       => [:literal,      i?: true, x?: false]
  include_examples 'parse', /(?=a)/i,        [0]          => [:lookahead,    i?: true, x?: false]
  include_examples 'parse', /(?=a)/i,        [0, 0]       => [:literal,      i?: true, x?: false]
  include_examples 'parse', /(a|b)/i,        [0]          => [:capture,      i?: true, x?: false]
  include_examples 'parse', /(a|b)/i,        [0, 0]       => [:alternation,  i?: true, x?: false]
  include_examples 'parse', /(a|b)/i,        [0, 0, 0]    => [:sequence,     i?: true, x?: false]
  include_examples 'parse', /(a|b)/i,        [0, 0, 0, 0] => [:literal,      i?: true, x?: false]
  include_examples 'parse', /(a)\1/i,        [1]          => [:number,       i?: true, x?: false]
  include_examples 'parse', /(a)\k<1>/i,     [1]          => [:number_ref,   i?: true, x?: false]
  include_examples 'parse', /(a)\g<1>/i,     [1]          => [:number_call,  i?: true, x?: false]
  include_examples 'parse', /[a]/i,          [0]          => [:character,    i?: true, x?: false]
  include_examples 'parse', /[a]/i,          [0, 0]       => [:literal,      i?: true, x?: false]
  include_examples 'parse', /[a-z]/i,        [0, 0]       => [:range,        i?: true, x?: false]
  include_examples 'parse', /[a-z]/i,        [0, 0, 0]    => [:literal,      i?: true, x?: false]
  include_examples 'parse', /[a&&z]/i,       [0, 0]       => [:intersection, i?: true, x?: false]
  include_examples 'parse', /[a&&z]/i,       [0, 0, 0, 0] => [:literal,      i?: true, x?: false]
  include_examples 'parse', /[[:ascii:]]/i,  [0, 0]       => [:ascii,        i?: true, x?: false]
  include_examples 'parse', /\p{word}/i,     [0]          => [:word,         i?: true, x?: false]
  include_examples 'parse', /(a)(?(1)b|c)/i, [1]          => [:open,         i?: true, x?: false]
  include_examples 'parse', /(a)(?(1)b|c)/i, [1, 0]       => [:condition,    i?: true, x?: false]
  include_examples 'parse', /(a)(?(1)b|c)/i, [1, 1]       => [:sequence,     i?: true, x?: false]
  include_examples 'parse', /(a)(?(1)b|c)/i, [1, 1, 0]    => [:literal,      i?: true, x?: false]
end
