# frozen_string_literal: true

require 'spec_helper'

RSpec.describe(Regexp::Parser) do
  specify('parse returns a root expression') do
    expect(RP.parse('abc')).to be_instance_of(Root)
  end

  specify('parse can be called with block') do
    expect(RP.parse('abc') { |root| root.class }).to eq Root
  end

  specify('parse root contains expressions') do
    root = RP.parse(/^a.c+[^one]{2,3}\b\d\\\C-C$/)
    expect(root.expressions).to all(be_a Regexp::Expression::Base)
  end

  specify('parse root options mi') do
    root = RP.parse(/[abc]/mi)

    expect(root.m?).to be true
    expect(root.i?).to be true
    expect(root.x?).to be false
  end

  specify('parse no quantifier target raises error') do
    expect { RP.parse('?abc') }.to raise_error(Regexp::Parser::Error)
  end

  specify('parse sequence no quantifier target raises error') do
    expect { RP.parse('abc|?def') }.to raise_error(Regexp::Parser::Error)
  end

  specify('is resistant against stack overflows') do
    pattern = "#{'(' * 9000}abc#{')' * 9000}" # Ruby's max regexp depth is 4096
    expect { @root = RP.parse(pattern) }.not_to raise_error
    expect(@root).to eq @root
    expect(@root.to_s).to eq(pattern)
    expect(@root.dig(*([0] * 8999)).to_s).to eq '((abc))'
    expect { @root.traverse(true) { |_, exp, _| exp } }.not_to raise_error
    expect { @root.each_expression(true) { |exp| exp } }.not_to raise_error
    expect { @root.each_expression(true) { |exp, _idx| exp } }.not_to raise_error
  end
end
