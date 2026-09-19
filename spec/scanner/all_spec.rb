# frozen_string_literal: true

require 'spec_helper'

RSpec.describe(Regexp::Scanner) do
  specify('scanner returns an array') do
    expect(RS.scan('abc')).to be_instance_of(Array)
  end

  specify('scanner returns tokens as arrays') do
    tokens = RS.scan('^abc+[^one]{2,3}\b\d\C-C$')
    expect(tokens).to all(be_a Array)
    expect(tokens.map(&:length)).to all(eq 5)
  end

  specify('scanner token count') do
    re = /^(one|two){2,3}([^d\]efm-qz\,\-]*)(ghi)+$/i
    expect(RS.scan(re).length).to eq 28
  end

  specify('nested scans keep their mutable state separate') do
    outer = /(?<word>a|b)\k<word>/
    inner = /[a-z&&[^aeiou]]+/ix
    expected_outer = RS.scan(outer)
    expected_inner = RS.scan(inner)
    nested_results = []

    result = RS.scan(outer) { nested_results << RS.scan(inner) }

    expect(result).to eq expected_outer
    expect(nested_results.length).to eq expected_outer.length
    expect(nested_results).to all(eq expected_inner)
  end
end
