require 'spec_helper'

RSpec.describe('passing options to scan') do
  def expect_type_tokens(tokens, type_tokens)
    expect(tokens.map { |type, token, *| [type, token] }).to eq(type_tokens)
  end

  it 'ignores options if parsing from a Regexp' do
    expect_type_tokens(
      RS.scan(/a+#c/im, options: ::Regexp::EXTENDED),
      [
        %i[literal literal],
        %i[quantifier one_or_more],
        %i[literal literal]
      ]
    )
  end

  it 'sets free_spacing based on options if parsing from a String' do
    expect_type_tokens(
      RS.scan('a+#c', options: ::Regexp::MULTILINE | ::Regexp::EXTENDED),
      [
        %i[literal literal],
        %i[quantifier one_or_more],
        %i[free_space comment]
      ]
    )
  end

  it 'does not set free_spacing if parsing from a String and passing no options' do
    expect_type_tokens(
      RS.scan('a+#c'),
      [
        %i[literal literal],
        %i[quantifier one_or_more],
        %i[literal literal]
      ]
    )
  end
end
