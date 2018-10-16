require 'spec_helper'

RSpec.describe('Refcall parsing') do
  specify('parse traditional number backref') do
    root = RP.parse('(abc)\\1', 'ruby/1.9')
    exp = root[1]

    expect(exp).to be_instance_of(Backreference::Number)
    expect(exp.number).to eq 1
  end

  specify('parse backref named ab') do
    root = RP.parse('(?<X>abc)\\k<X>', 'ruby/1.9')
    exp = root[1]

    expect(exp).to be_instance_of(Backreference::Name)
    expect(exp.name).to eq 'X'
  end

  specify('parse backref named sq') do
    root = RP.parse("(?<X>abc)\\k'X'", 'ruby/1.9')
    exp = root[1]

    expect(exp).to be_instance_of(Backreference::Name)
    expect(exp.name).to eq 'X'
  end

  specify('parse backref number ab') do
    root = RP.parse('(abc)\\k<1>', 'ruby/1.9')
    exp = root[1]

    expect(exp).to be_instance_of(Backreference::Number)
    expect(exp.number).to eq 1
  end

  specify('parse backref number sq') do
    root = RP.parse("(abc)\\k'1'", 'ruby/1.9')
    exp = root[1]

    expect(exp).to be_instance_of(Backreference::Number)
    expect(exp.number).to eq 1
  end

  specify('parse backref number relative ab') do
    root = RP.parse('(abc)\\k<-1>', 'ruby/1.9')
    exp = root[1]

    expect(exp).to be_instance_of(Backreference::NumberRelative)
    expect(exp.number).to eq(-1)
  end

  specify('parse backref number relative sq') do
    root = RP.parse("(abc)\\k'-1'", 'ruby/1.9')
    exp = root[1]

    expect(exp).to be_instance_of(Backreference::NumberRelative)
    expect(exp.number).to eq(-1)
  end

  specify('parse backref name call ab') do
    root = RP.parse('(?<X>abc)\\g<X>', 'ruby/1.9')
    exp = root[1]

    expect(exp).to be_instance_of(Backreference::NameCall)
    expect(exp.name).to eq 'X'
  end

  specify('parse backref name call sq') do
    root = RP.parse("(?<X>abc)\\g'X'", 'ruby/1.9')
    exp = root[1]

    expect(exp).to be_instance_of(Backreference::NameCall)
    expect(exp.name).to eq 'X'
  end

  specify('parse backref number call ab') do
    root = RP.parse('(abc)\\g<1>', 'ruby/1.9')
    exp = root[1]

    expect(exp).to be_instance_of(Backreference::NumberCall)
    expect(exp.number).to eq 1
  end

  specify('parse backref number call sq') do
    root = RP.parse("(abc)\\g'1'", 'ruby/1.9')
    exp = root[1]

    expect(exp).to be_instance_of(Backreference::NumberCall)
    expect(exp.number).to eq 1
  end

  specify('parse backref number relative call ab') do
    root = RP.parse('(abc)\\g<-1>', 'ruby/1.9')
    exp = root[1]

    expect(exp).to be_instance_of(Backreference::NumberCallRelative)
    expect(exp.number).to eq(-1)
  end

  specify('parse backref number relative call sq') do
    root = RP.parse("(abc)\\g'-1'", 'ruby/1.9')
    exp = root[1]

    expect(exp).to be_instance_of(Backreference::NumberCallRelative)
    expect(exp.number).to eq(-1)
  end

  specify('parse backref number relative forward call ab') do
    root = RP.parse('\\g<+1>(abc)', 'ruby/1.9')
    exp = root[0]

    expect(exp).to be_instance_of(Backreference::NumberCallRelative)
    expect(exp.number).to eq 1
  end

  specify('parse backref number relative forward call sq') do
    root = RP.parse("\\g'+1'(abc)", 'ruby/1.9')
    exp = root[0]

    expect(exp).to be_instance_of(Backreference::NumberCallRelative)
    expect(exp.number).to eq 1
  end

  specify('parse backref name recursion level ab') do
    root = RP.parse('(?<X>abc)\\k<X-0>', 'ruby/1.9')
    exp = root[1]

    expect(exp).to be_instance_of(Backreference::NameRecursionLevel)
    expect(exp.name).to eq 'X'
    expect(exp.recursion_level).to eq 0
  end

  specify('parse backref name recursion level sq') do
    root = RP.parse("(?<X>abc)\\k'X-0'", 'ruby/1.9')
    exp = root[1]

    expect(exp).to be_instance_of(Backreference::NameRecursionLevel)
    expect(exp.name).to eq 'X'
    expect(exp.recursion_level).to eq 0
  end

  specify('parse backref number recursion level ab') do
    root = RP.parse('(abc)\\k<1-0>', 'ruby/1.9')
    exp = root[1]

    expect(exp).to be_instance_of(Backreference::NumberRecursionLevel)
    expect(exp.number).to eq 1
    expect(exp.recursion_level).to eq 0
  end

  specify('parse backref number recursion level sq') do
    root = RP.parse("(abc)\\k'1-0'", 'ruby/1.9')
    exp = root[1]

    expect(exp).to be_instance_of(Backreference::NumberRecursionLevel)
    expect(exp.number).to eq 1
    expect(exp.recursion_level).to eq 0
  end

  specify('parse backref negative number recursion level') do
    root = RP.parse("(abc)\\k'-1+0'", 'ruby/1.9')
    exp = root[1]

    expect(exp).to be_instance_of(Backreference::NumberRecursionLevel)
    expect(exp.number).to eq(-1)
    expect(exp.recursion_level).to eq 0
  end

  specify('parse backref number positive recursion level') do
    root = RP.parse("(abc)\\k'1+1'", 'ruby/1.9')
    exp = root[1]

    expect(exp).to be_instance_of(Backreference::NumberRecursionLevel)
    expect(exp.number).to eq 1
    expect(exp.recursion_level).to eq 1
  end

  specify('parse backref number negative recursion level') do
    root = RP.parse("(abc)\\k'1-1'", 'ruby/1.9')
    exp = root[1]

    expect(exp).to be_instance_of(Backreference::NumberRecursionLevel)
    expect(exp.number).to eq 1
    expect(exp.recursion_level).to eq(-1)
  end
end
