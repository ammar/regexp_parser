require 'spec_helper'

RSpec.describe('Group parsing') do
  specify('parse root options mi') do
    t = RP.parse(/[abc]/mi, 'ruby/1.8')

    expect(t.m?).to be true
    expect(t.i?).to be true
    expect(t.x?).to be false
  end

  specify('parse option group') do
    t = RP.parse(/(?m:a)/, 'ruby/1.8')

    expect(t[0]).to be_instance_of(Group::Options)
    expect(t[0].token).to eq :options

    expect(t[0].m?).to be true
    expect(t[0].i?).to be false
    expect(t[0].x?).to be false

    expect(t[0].option_changes[:m]).to be true
    expect(t[0].option_changes[:i]).to be_nil
  end

  specify('parse self defeating option group') do
    t = RP.parse(/(?m-m:a)/, 'ruby/1.8')

    expect(t[0].m?).to be false
    expect(t[0].i?).to be false
    expect(t[0].x?).to be false

    expect(t[0].option_changes[:m]).to be false
    expect(t[0].option_changes[:i]).to be_nil
  end

  specify('parse nested options activate one') do
    t = RP.parse(/(?x-mi:a(?m:b))/, 'ruby/1.8')

    expect(t[0].m?).to be false
    expect(t[0].i?).to be false
    expect(t[0].x?).to be true

    expect(t[0][1].m?).to be true
    expect(t[0][1].i?).to be false
    expect(t[0][1].x?).to be true

    expect(t[0][1].option_changes[:m]).to be true
    expect(t[0][1].option_changes[:i]).to be_nil
    expect(t[0][1].option_changes[:x]).to be_nil
  end

  specify('parse nested options deactivate one') do
    t = RP.parse(/(?ix-m:a(?-i:b))/, 'ruby/1.8')

    expect(t[0].m?).to be false
    expect(t[0].i?).to be true
    expect(t[0].x?).to be true

    expect(t[0][1].m?).to be false
    expect(t[0][1].i?).to be false
    expect(t[0][1].x?).to be true

    expect(t[0][1].option_changes[:i]).to be false
    expect(t[0][1].option_changes[:m]).to be_nil
    expect(t[0][1].option_changes[:x]).to be_nil
  end

  specify('parse nested options invert all') do
    t = RP.parse('(?xi-m:a(?m-ix:b))', 'ruby/1.8')

    expect(t[0].m?).to be false
    expect(t[0].i?).to be true
    expect(t[0].x?).to be true

    expect(t[0][1].m?).to be true
    expect(t[0][1].i?).to be false
    expect(t[0][1].x?).to be false

    expect(t[0][1].option_changes[:m]).to be true
    expect(t[0][1].option_changes[:i]).to be false
    expect(t[0][1].option_changes[:x]).to be false
  end

  specify('parse nested options affect literal subexpressions') do
    t = RP.parse(/(?x-mi:a(?m:b))/, 'ruby/1.8')

    expect(t[0][0].m?).to be false
    expect(t[0][0].i?).to be false
    expect(t[0][0].x?).to be true

    expect(t[0][1][0].m?).to be true
    expect(t[0][1][0].i?).to be false
    expect(t[0][1][0].x?).to be true
  end

  specify('parse option switch group') do
    t = RP.parse(/a(?i-m)b/m, 'ruby/1.8')

    expect(t[1]).to be_instance_of(Group::Options)
    expect(t[1].token).to eq :options_switch

    expect(t[1].m?).to be false
    expect(t[1].i?).to be true
    expect(t[1].x?).to be false

    expect(t[1].option_changes[:i]).to be true
    expect(t[1].option_changes[:m]).to be false
    expect(t[1].option_changes[:x]).to be_nil
  end

  specify('parse option switch affects following expressions') do
    t = RP.parse(/a(?i-m)b/m, 'ruby/1.8')

    expect(t[0].m?).to be true
    expect(t[0].i?).to be false
    expect(t[0].x?).to be false

    expect(t[2].m?).to be false
    expect(t[2].i?).to be true
    expect(t[2].x?).to be false
  end

  specify('parse option switch in group') do
    t = RP.parse(/(a(?i-m)b)c/m, 'ruby/1.8')

    group1 = t[0]

    expect(group1.m?).to be true
    expect(group1.i?).to be false
    expect(group1.x?).to be false

    expect(group1[0].m?).to be true
    expect(group1[0].i?).to be false
    expect(group1[0].x?).to be false

    expect(group1[1].m?).to be false
    expect(group1[1].i?).to be true
    expect(group1[1].x?).to be false

    expect(group1[2].m?).to be false
    expect(group1[2].i?).to be true
    expect(group1[2].x?).to be false

    expect(t[1].m?).to be true
    expect(t[1].i?).to be false
    expect(t[1].x?).to be false
  end

  specify('parse nested option switch in group') do
    t = RP.parse(/((?i-m)(a(?-i)b))/m, 'ruby/1.8')

    group2 = t[0][1]

    expect(group2.m?).to be false
    expect(group2.i?).to be true
    expect(group2.x?).to be false

    expect(group2[0].m?).to be false
    expect(group2[0].i?).to be true
    expect(group2[0].x?).to be false

    expect(group2[1].m?).to be false
    expect(group2[1].i?).to be false
    expect(group2[1].x?).to be false

    expect(group2[2].m?).to be false
    expect(group2[2].i?).to be false
    expect(group2[2].x?).to be false
  end

  specify('parse options dau') do
    t = RP.parse('(?dua:abc)')

    expect(t[0].d?).to be false
    expect(t[0].a?).to be true
    expect(t[0].u?).to be false
  end

  specify('parse nested options dau') do
    t = RP.parse('(?u:a(?d:b))')

    expect(t[0].u?).to be true
    expect(t[0].d?).to be false
    expect(t[0].a?).to be false

    expect(t[0][1].d?).to be true
    expect(t[0][1].a?).to be false
    expect(t[0][1].u?).to be false
  end

  specify('parse nested options da') do
    t = RP.parse('(?di-xm:a(?da-x:b))')

    expect(t[0].d?).to be true
    expect(t[0].i?).to be true
    expect(t[0].m?).to be false
    expect(t[0].x?).to be false
    expect(t[0].a?).to be false
    expect(t[0].u?).to be false

    expect(t[0][1].d?).to be false
    expect(t[0][1].a?).to be true
    expect(t[0][1].u?).to be false
    expect(t[0][1].x?).to be false
    expect(t[0][1].m?).to be false
    expect(t[0][1].i?).to be true
  end

  specify('parse lookahead') do
    t = RP.parse('(?=abc)(?!def)', 'ruby/1.8')

    expect(t[0]).to be_a(Assertion::Lookahead)

    expect(t[1]).to be_a(Assertion::NegativeLookahead)
  end

  specify('parse lookbehind') do
    t = RP.parse('(?<=abc)(?<!def)', 'ruby/1.9')

    expect(t[0]).to be_a(Assertion::Lookbehind)

    expect(t[1]).to be_a(Assertion::NegativeLookbehind)
  end

  specify('parse comment') do
    t = RP.parse('a(?# is for apple)b(?# for boy)c(?# cat)')

    [1, 3, 5].each do |i|
      expect(t[i]).to be_a(Group::Comment)

      expect(t[i].type).to eq :group
      expect(t[i].token).to eq :comment
    end
  end

  specify('parse absence group', if: ruby_version_at_least('2.4.1')) do
    t = RP.parse('a(?~b)c(?~d)e')

    [1, 3].each do |i|
      expect(t[i]).to be_a(Group::Absence)

      expect(t[i].type).to eq :group
      expect(t[i].token).to eq :absence
    end
  end

  specify('parse group number') do
    t = RP.parse('(a)(?=b)((?:c)(d|(e)))')
    expect(t[0].number).to eq 1
    expect(t[1]).not_to respond_to(:number)
    expect(t[2].number).to eq 2
    expect(t[2][0]).not_to respond_to(:number)
    expect(t[2][1].number).to eq 3
    expect(t[2][1][0][1][0].number).to eq 4
  end

  specify('parse group number at level') do
    t = RP.parse('(a)(?=b)((?:c)(d|(e)))')
    expect(t[0].number_at_level).to eq 1
    expect(t[1]).not_to respond_to(:number_at_level)
    expect(t[2].number_at_level).to eq 2
    expect(t[2][0]).not_to respond_to(:number_at_level)
    expect(t[2][1].number_at_level).to eq 1
    expect(t[2][1][0][1][0].number_at_level).to eq 1
  end
end
