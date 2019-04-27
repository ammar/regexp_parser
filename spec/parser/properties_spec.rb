require 'spec_helper'

RSpec.describe('Property parsing') do
  modes = %w[p P]
  example_props = [
    'Alnum',
    'Any',
    'Age=1.1',
    'Dash',
    'di',
    'Default_Ignorable_Code_Point',
    'Math',
    'Noncharacter-Code_Point', # test dash
    'sd',
    'Soft Dotted', # test whitespace
    'sterm',
    'xidc',
    'XID_Continue',
    'Emoji',
    'InChessSymbols'
  ]

  modes.each do |mode|
    token_type = mode == 'p' ? :property : :nonproperty

    example_props.each do |property|
      specify("parse_#{token_type}_#{property}") do
        t = RP.parse("ab\\#{mode}{#{property}}", '*')

        expect(t.expressions.last).to be_a(UnicodeProperty::Base)

        expect(t.expressions.last.type).to eq token_type
        expect(t.expressions.last.name).to eq property
      end
    end
  end

  specify('parse all properties of current ruby') do
    unsupported = RegexpPropertyValues.all_for_current_ruby.reject do |prop|
      begin
        RP.parse("\\p{#{prop}}")
      rescue SyntaxError, StandardError
        nil
      end
    end
    expect(unsupported).to be_empty
  end

  specify('parse property negative') do
    t = RP.parse('ab\\p{L}cd', 'ruby/1.9')

    expect(t[1]).not_to be_negative
  end

  specify('parse nonproperty negative') do
    t = RP.parse('ab\\P{L}cd', 'ruby/1.9')

    expect(t[1]).to be_negative
  end

  specify('parse caret nonproperty negative') do
    t = RP.parse('ab\\p{^L}cd', 'ruby/1.9')

    expect(t[1]).to be_negative
  end

  specify('parse double negated property negative') do
    t = RP.parse('ab\\P{^L}cd', 'ruby/1.9')

    expect(t[1]).not_to be_negative
  end

  specify('parse property shortcut') do
    expect(RP.parse('\\p{mark}')[0].shortcut).to eq 'm'
    expect(RP.parse('\\p{sc}')[0].shortcut).to eq 'sc'
    expect(RP.parse('\\p{in_bengali}')[0].shortcut).to be_nil
  end

  specify('parse property age') do
    t = RP.parse('ab\\p{age=5.2}cd', 'ruby/1.9')

    expect(t[1]).to be_a(UnicodeProperty::Age)
  end

  specify('parse property derived') do
    t = RP.parse('ab\\p{Math}cd', 'ruby/1.9')

    expect(t[1]).to be_a(UnicodeProperty::Derived)
  end

  specify('parse property script') do
    t = RP.parse('ab\\p{Hiragana}cd', 'ruby/1.9')

    expect(t[1]).to be_a(UnicodeProperty::Script)
  end

  specify('parse property script V1 9 3') do
    t = RP.parse('ab\\p{Brahmi}cd', 'ruby/1.9.3')

    expect(t[1]).to be_a(UnicodeProperty::Script)
  end

  specify('parse property script V2 2 0') do
    t = RP.parse('ab\\p{Caucasian_Albanian}cd', 'ruby/2.2')

    expect(t[1]).to be_a(UnicodeProperty::Script)
  end

  specify('parse property block') do
    t = RP.parse('ab\\p{InArmenian}cd', 'ruby/1.9')

    expect(t[1]).to be_a(UnicodeProperty::Block)
  end

  specify('parse property following literal') do
    t = RP.parse('ab\\p{Lu}cd', 'ruby/1.9')

    expect(t[2]).to be_a(Literal)
  end

  specify('parse abandoned newline property') do
    t = RP.parse('\\p{newline}', 'ruby/1.9')
    expect(t.expressions.last).to be_a(UnicodeProperty::Base)

    expect { RP.parse('\\p{newline}', 'ruby/2.0') }.to raise_error(Regexp::Syntax::NotImplementedError)
  end
end
