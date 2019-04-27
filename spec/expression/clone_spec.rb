require 'spec_helper'

RSpec.describe('Expression#clone') do
  specify('Base#clone') do
    root = RP.parse(/^(?i:a)b+$/i)
    copy = root.clone

    expect(root.object_id).not_to eq copy.object_id
    expect(root.text).to eq copy.text
    expect(root.text.object_id).not_to eq copy.text.object_id

    root_1 = root[1]
    copy_1 = copy[1]

    expect(root_1.options).to eq copy_1.options
    expect(root_1.options.object_id).not_to eq copy_1.options.object_id

    root_2 = root[2]
    copy_2 = copy[2]

    expect(root_2).to be_quantified
    expect(copy_2).to be_quantified
    expect(root_2.quantifier.text).to eq copy_2.quantifier.text
    expect(root_2.quantifier.text.object_id).not_to eq copy_2.quantifier.text.object_id
    expect(root_2.quantifier.object_id).not_to eq copy_2.quantifier.object_id
  end

  specify('Subexpression#clone') do
    root = RP.parse(/^a(b([cde])f)g$/)
    copy = root.clone

    expect(root).to respond_to(:expressions)
    expect(copy).to respond_to(:expressions)
    expect(root.expressions.object_id).not_to eq copy.expressions.object_id
    copy.expressions.each_with_index do |exp, index|
      expect(root[index].object_id).not_to eq exp.object_id
    end
    copy[2].each_with_index do |exp, index|
      expect(root[2][index].object_id).not_to eq exp.object_id
    end
  end

  specify('Group::Named#clone') do
    root = RP.parse('^(?<somename>a)+bc$')
    copy = root.clone

    root_1 = root[1]
    copy_1 = copy[1]

    expect(root_1.name).to eq copy_1.name
    expect(root_1.name.object_id).not_to eq copy_1.name.object_id
    expect(root_1.text).to eq copy_1.text
    expect(root_1.expressions.object_id).not_to eq copy_1.expressions.object_id
    copy_1.expressions.each_with_index do |exp, index|
      expect(root_1[index].object_id).not_to eq exp.object_id
    end
  end
end
