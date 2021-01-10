require 'spec_helper'

RSpec.describe('passing custom options to parse') do
  it 'treats them as Expression::Options and forwards them to the Scanner' do
    expect(RS).to receive(:scan).with('foo', options: Regexp::Options.new({ i: true }))
    root = RP.parse('foo', options: 'i')
    expect(root).to be_case_insensitive
  end
end
