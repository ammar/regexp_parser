require 'spec_helper'

RSpec.describe('Keep parsing', if: ruby_version_at_least('2.0.0')) do
  specify('parse keep') do
    regexp = /ab\Kcd/
    root = RP.parse(regexp)

    expect(root[1]).to be_instance_of(Keep::Mark)
    expect(root[1].text).to eq '\\K'
  end

  specify('parse keep nested') do
    regexp = /(a\\\Kb)/
    root = RP.parse(regexp)

    expect(root[0][2]).to be_instance_of(Keep::Mark)
    expect(root[0][2].text).to eq '\\K'
  end
end
