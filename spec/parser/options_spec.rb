require 'spec_helper'

RSpec.describe('passing options to parse') do
  it 'ignores options if parsing from a Regexp' do
    root = RP.parse(/a+/ix, options: ::Regexp::MULTILINE)

    expect(root.options).to eq(i: true, x: true)
  end

  it 'sets options if parsing from a String' do
    root = RP.parse('a+', options: ::Regexp::MULTILINE | ::Regexp::EXTENDED)

    expect(root.options).to eq(m: true, x: true)
  end

  it 'allows options to not be supplied when parsing from a Regexp' do
    root = RP.parse(/a+/ix)

    expect(root.options).to eq(i: true, x: true)
  end

  it 'has an empty option-hash when parsing from a String and passing no options' do
    root = RP.parse('a+')

    expect(root.options).to be_empty
  end
end
