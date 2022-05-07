require 'spec_helper'

RSpec.describe('ExpressionTests') do
  specify('#type?') do
    root = RP.parse(/abcd|(ghij)|[klmn]/)

    alt = root.first

    expect(alt.type?(:meta)).to be true
    expect(alt.type?(:escape)).to be false
    expect(alt.type?(%i[meta escape])).to be true
    expect(alt.type?(%i[literal escape])).to be false
    expect(alt.type?(:*)).to be true
    expect(alt.type?([:*])).to be true
    expect(alt.type?(%i[literal escape *])).to be true

    seq_1 = alt[0]
    expect(seq_1.type?(:expression)).to be true
    expect(seq_1.first.type?(:literal)).to be true

    seq_2 = alt[1]
    expect(seq_2.type?(:*)).to be true
    expect(seq_2.first.type?(:group)).to be true

    seq_3 = alt[2]
    expect(seq_3.first.type?(:set)).to be true
  end

  specify('#is?') do
    root = RP.parse(/.+|\.?/)

    expect(root.is?(:*)).to be true

    alt = root.first
    expect(alt.is?(:*)).to be true
    expect(alt.is?(:alternation)).to be true
    expect(alt.is?(:alternation, :meta)).to be true

    seq_1 = alt[0]
    expect(seq_1.is?(:sequence)).to be true
    expect(seq_1.is?(:sequence, :expression)).to be true

    expect(seq_1.first.is?(:dot)).to be true
    expect(seq_1.first.is?(:dot, :escape)).to be false
    expect(seq_1.first.is?(:dot, :meta)).to be true
    expect(seq_1.first.is?(:dot, %i[escape meta])).to be true

    seq_2 = alt[1]
    expect(seq_2.first.is?(:dot)).to be true
    expect(seq_2.first.is?(:dot, :escape)).to be true
    expect(seq_2.first.is?(:dot, :meta)).to be false
    expect(seq_2.first.is?(:dot, %i[meta escape])).to be true
  end

  specify('#one_of?') do
    root = RP.parse(/\Aab(c[\w])d|e.\z/)

    expect(root.one_of?(:*)).to be true
    expect(root.one_of?(:* => :*)).to be true
    expect(root.one_of?(:* => [:*])).to be true

    alt = root.first
    expect(alt.one_of?(:*)).to be true
    expect(alt.one_of?(:meta)).to be true
    expect(alt.one_of?(:meta, :alternation)).to be true
    expect(alt.one_of?(meta: %i[dot bogus])).to be false
    expect(alt.one_of?(meta: %i[dot alternation])).to be true

    seq_1 = alt[0]
    expect(seq_1.one_of?(:expression)).to be true
    expect(seq_1.one_of?(expression: :sequence)).to be true

    expect(seq_1.first.one_of?(:anchor)).to be true
    expect(seq_1.first.one_of?(anchor: :bos)).to be true
    expect(seq_1.first.one_of?(anchor: :eos)).to be false
    expect(seq_1.first.one_of?(anchor: %i[escape meta bos])).to be true
    expect(seq_1.first.one_of?(anchor: %i[escape meta eos])).to be false

    seq_2 = alt[1]
    expect(seq_2.first.one_of?(:literal)).to be true

    expect(seq_2[1].one_of?(:meta)).to be true
    expect(seq_2[1].one_of?(meta: :dot)).to be true
    expect(seq_2[1].one_of?(meta: :alternation)).to be false
    expect(seq_2[1].one_of?(meta: [:dot])).to be true

    expect(seq_2.last.one_of?(:group)).to be false
    expect(seq_2.last.one_of?(group: [:*])).to be false
    expect(seq_2.last.one_of?(group: [:*], meta: :*)).to be false

    expect(seq_2.last.one_of?(:meta => [:*], :* => :*)).to be true
    expect(seq_2.last.one_of?(meta: [:*], anchor: :*)).to be true
    expect(seq_2.last.one_of?(meta: [:*], anchor: :eos)).to be true
    expect(seq_2.last.one_of?(meta: [:*], anchor: [:bos])).to be false
    expect(seq_2.last.one_of?(meta: [:*], anchor: %i[bos eos])).to be true

    expect { root.one_of?(Object.new) }.to raise_error(ArgumentError)
  end

  specify('#==') do
    expect(RP.parse(/a/)).to                    eq RP.parse(/a/)
    expect(RP.parse(/a/)).not_to                eq RP.parse(/B/)

    expect(RP.parse(/a+/)).to                   eq RP.parse(/a+/)
    expect(RP.parse(/a+/)).not_to               eq RP.parse(/a++/)
    expect(RP.parse(/a+/)).not_to               eq RP.parse(/a?/)

    expect(RP.parse(/\A/)).to                   eq RP.parse(/\A/)
    expect(RP.parse(/\A/)).not_to               eq RP.parse(/\b/)

    expect(RP.parse(/[a]/)).to                  eq RP.parse(/[a]/)
    expect(RP.parse(/[a]/)).not_to              eq RP.parse(/[B]/)

    expect(RP.parse(/(a)/)).to                  eq RP.parse(/(a)/)
    expect(RP.parse(/(a)/)).not_to              eq RP.parse(/(B)/)

    expect(RP.parse(/(a|A)/)).to                eq RP.parse(/(a|A)/)
    expect(RP.parse(/(a|A)/)).not_to            eq RP.parse(/(a|B)/)

    expect(RP.parse(/(?:a)/)).to                eq RP.parse(/(?:a)/)
    expect(RP.parse(/(?:a)/)).not_to            eq RP.parse(/(a)/)

    expect(RP.parse(/(?<a>a)/)).to              eq RP.parse(/(?<a>a)/)
    expect(RP.parse(/(?<a>a)/)).not_to          eq RP.parse(/(?<a>B)/)
    expect(RP.parse(/(?<a>a)/)).not_to          eq RP.parse(/(?<B>a)/)
    expect(RP.parse(/(?<a>a)/)).not_to          eq RP.parse(/(?'a'a)/)

    expect(RP.parse(/(a)(x)(?(1)T|F)/)).to      eq RP.parse(/(a)(x)(?(1)T|F)/)
    expect(RP.parse(/(a)(x)(?(1)T|F)/)).not_to  eq RP.parse(/(a)(x)(?(2)T|F)/)
    expect(RP.parse(/(a)(x)(?(1)T|F)/)).not_to  eq RP.parse(/(B)(x)(?(1)T|F)/)
    expect(RP.parse(/(a)(x)(?(1)T|F)/)).not_to  eq RP.parse(/(a)(x)(?(1)T|T)/)

    expect(RP.parse(/a+/)[0].quantifier).to     eq RP.parse(/a+/)[0].quantifier
    expect(RP.parse(/a+/)[0].quantifier).not_to eq RP.parse(/a++/)[0].quantifier
    expect(RP.parse(/a+/)[0].quantifier).not_to eq RP.parse(/a?/)[0].quantifier
    expect(RP.parse(/a+/)[0].quantifier).not_to eq RP.parse(/a{1,}/)[0].quantifier

    # active options should differentiate expressions
    expect(RP.parse(/a/)[0]).to                 eq RP.parse(/a/)[0]
    expect(RP.parse(/a/i)[0]).not_to            eq RP.parse(/a/)[0]
    expect(RP.parse(/(?i)a/)[1]).not_to         eq RP.parse(/a/)[0]
    expect(RP.parse(/(?i:a)/)[0][0]).not_to     eq RP.parse(/a/)[0]

    # levels should be ignored
    expect(RP.parse(/([a])/)[0][0][0]).to       eq RP.parse(/a/)[0]
  end
end
