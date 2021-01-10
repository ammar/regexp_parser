require 'spec_helper'

RSpec.describe('passing options to scan') do
  it 'sets free_spacing based on options if scanning from a String' do
    result = RS.scan('a#c', options: 'x')
    expect(result.last[0]).to eq(:free_space)
  end
end
