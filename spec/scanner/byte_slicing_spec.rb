# frozen_string_literal: true

require 'spec_helper'

RSpec.describe('scanner byte slicing') do
  expected = [
    [:literal, :literal, 'ä😀', 0, 2],
    [:quantifier, :one_or_more, '+', 2, 3],
    [:type, :digit, '\d', 3, 5],
    [:property, :letter, '\p{L}', 5, 10],
  ]

  [Encoding::UTF_8, Encoding::BINARY, Encoding::US_ASCII, Encoding::ISO_8859_1].each do |encoding|
    it "preserves bytes and character positions for input labeled #{encoding}" do
      input = 'ä😀+\d\p{L}'.dup.force_encoding(encoding).freeze
      tokens = RS.scan(input)

      expect(tokens).to eq expected
      expect(tokens.map { |token| token[2].encoding }).to all(eq Encoding::UTF_8)
      expect(input.encoding).to eq encoding
      expect(input.bytes).to eq 'ä😀+\d\p{L}'.bytes
    end
  end

  it 'does not mutate input via token callbacks' do
    input = 'ä😀+\d\p{L}'.dup
    tokens = RS.scan(input) { input.replace('changed') }

    expect(tokens).to eq expected
    expect(input).to eq 'changed'
  end

  it 'does not share mutable token text with the input' do
    input = 'ä😀+\d\p{L}'.dup
    tokens = RS.scan(input)
    tokens.first[2].replace('changed')

    expect(input).to eq 'ä😀+\d\p{L}'
  end
end
