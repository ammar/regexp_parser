require 'spec_helper'

RSpec.describe('Refcall parsing') do
  include_examples 'parse', /(abc)\1/,        1 => [Backreference::Number, reference: 1]

  include_examples 'parse', /(?<X>abc)\k<X>/, 1 => [Backreference::Name, name: 'X', reference: 'X']
  include_examples 'parse', /(?<X>abc)\k'X'/, 1 => [Backreference::Name, name: 'X', reference: 'X']
  include_examples 'parse', /(abc)\k<1>/,     1 => [Backreference::Number, number: 1, reference: 1]
  include_examples 'parse', /(abc)\k<001>/,   1 => [Backreference::Number, number: 1, reference: 1]
  include_examples 'parse', /(abc)\k<-1>/,    1 => [Backreference::NumberRelative, number: -1, reference: 1]
  include_examples 'parse', /(abc)\k'-1'/,    1 => [Backreference::NumberRelative, number: -1, reference: 1]
  include_examples 'parse', /(abc)\k'-001'/,  1 => [Backreference::NumberRelative, number: -1, reference: 1]
  include_examples 'parse', /(?<X>abc)\g<X>/, 1 => [Backreference::NameCall, reference: 'X']
  include_examples 'parse', /(abc)\g<1>/,     1 => [Backreference::NumberCall, reference: 1]
  include_examples 'parse', '(abc)\g<001>',   1 => [Backreference::NumberCall, reference: 1]
  include_examples 'parse', '\g<0>',          0 => [Backreference::NumberCall, reference: 0]
  include_examples 'parse', /(abc)\g<-1>/,    1 => [Backreference::NumberCallRelative, reference: 1]
  include_examples 'parse', /(abc)\g<-001>/,  1 => [Backreference::NumberCallRelative, reference: 1]
  include_examples 'parse', /\g<+1>(abc)/,    0 => [Backreference::NumberCallRelative, reference: 1]

  include_examples 'parse', /(?<X>abc)\k<X-0>/,
    1 => [Backreference::NameRecursionLevel, name: 'X', recursion_level: 0]

  include_examples 'parse', /(abc)\k<1-0>/,
    1 => [Backreference::NumberRecursionLevel, number: 1, recursion_level: 0]
  include_examples 'parse', /(abc)\k<1-0>/,
    1 => [Backreference::NumberRecursionLevel, number: 1, recursion_level: 0]
  include_examples 'parse', /(abc)\k<-1+0>/,
    1 => [Backreference::NumberRecursionLevel, number: -1, recursion_level: 0]
  include_examples 'parse', /(abc)\k<1+1>/,
    1 => [Backreference::NumberRecursionLevel, number: 1, recursion_level: 1]
  include_examples 'parse', /(abc)\k<1-1>/,
    1 => [Backreference::NumberRecursionLevel, number: 1, recursion_level: -1]

  # test #effective_number/#reference for complex cases
  include_examples 'parse', '(abc)(def)\k<-1>(ghi)\k<-3>\k<-1>',
    2 => [:number_rel_ref, reference: 2],
    4 => [:number_rel_ref, reference: 1],
    5 => [:number_rel_ref, reference: 3]

  include_examples 'parse', '\g<+1>(abc)\g<+2>(def)(ghi)\g<-2>',
    0 => [:number_rel_call, reference: 1],
    2 => [:number_rel_call, reference: 3],
    5 => [:number_rel_call, reference: 2]

  specify('parse backref referenced_expression') do
    root = RP.parse('(abc)(def)\\k<-1>(ghi)\\k<-3>\\k<-1>')
    exp1 = root[2]
    exp2 = root[4]
    exp3 = root[5]

    expect([exp1, exp2, exp3]).to all be_instance_of(Backreference::NumberRelative)

    expect(exp1.referenced_expression).to eq root[1]
    expect(exp1.referenced_expression.to_s).to eq '(def)'
    expect(exp2.referenced_expression).to eq root[0]
    expect(exp2.referenced_expression.to_s).to eq '(abc)'
    expect(exp3.referenced_expression).to eq root[3]
    expect(exp3.referenced_expression.to_s).to eq '(ghi)'
  end

  specify('parse backref referenced_expressions (multiplex)') do
    root = RP.parse('(?<a>A)(?<a>B)\\k<a>')
    exp = root.last

    expect(exp.referenced_expressions).to eq [root[0], root[1]]
    expect(exp.referenced_expressions.map(&:to_s)).to eq ['(?<a>A)', '(?<a>B)']
  end

  specify('parse backref call referenced_expression') do
    root = RP.parse('\\g<+1>(abc)\\g<+2>(def)(ghi)\\g<-2>')
    exp1 = root[0]
    exp2 = root[2]
    exp3 = root[5]

    expect([exp1, exp2, exp3]).to all be_instance_of(Backreference::NumberCallRelative)
    expect(exp1.referenced_expression).to eq root[1]
    expect(exp1.referenced_expression.to_s).to eq '(abc)'
    expect(exp2.referenced_expression).to eq root[4]
    expect(exp2.referenced_expression.to_s).to eq '(ghi)'
    expect(exp3.referenced_expression).to eq root[3]
    expect(exp3.referenced_expression.to_s).to eq '(def)'
  end

  specify('parse backref call referenced_expression root') do
    root = RP.parse('\g<0>')
    expect(root[0].referenced_expression).to eq root
  end

  specify('parse invalid reference') do
    expect { RP.parse('\1') }.to raise_error(/Invalid reference/)
    expect { RP.parse('1\1') }.to raise_error(/Invalid reference/)
    expect { RP.parse('\8') }.to raise_error(/Invalid reference/)
    expect { RP.parse('8\8') }.to raise_error(/Invalid reference/)
    expect { RP.parse('(a)\2') }.to raise_error(/Invalid reference/)
    expect { RP.parse('\k<1>') }.to raise_error(/Invalid reference/)
    expect { RP.parse('\k<+1>') }.to raise_error(/Invalid reference/)
    expect { RP.parse('\k<+2>(a)') }.to raise_error(/Invalid reference/)
    expect { RP.parse('\k<-1>') }.to raise_error(/Invalid reference/)
    expect { RP.parse('(a)\k<-2>') }.to raise_error(/Invalid reference/)
    expect { RP.parse('\k<1+1>') }.to raise_error(/Invalid reference/)
    expect { RP.parse('\k<1-1>') }.to raise_error(/Invalid reference/)
    expect { RP.parse('\k<name>') }.to raise_error(/Invalid reference/)
    expect { RP.parse('(?<other>)\k<name>') }.to raise_error(/Invalid reference/)
  end
end
