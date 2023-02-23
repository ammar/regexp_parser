require 'spec_helper'

RSpec.describe('Expression::Shared#te,ts') do
  # Many tokens/expressions have their own tests for #te and #ts.
  # This is an integration-like test to ensure they are correct in conjunction.
  it 'is correct irrespective of nesting or preceding tokens' do
    regexp = regexp_with_all_features
    source = regexp.source
    root = RP.parse(regexp)

    checked_exps = root.each_expression.with_object([]) do |(exp), acc|
      acc.each { |e| fail "dupe: #{[e, exp]}" if e.to_s == exp.to_s }
      acc << exp unless exp.is_a?(Sequence) || exp.is_a?(WhiteSpace)
    end
    expect(checked_exps).not_to be_empty

    checked_exps.each do |exp|
      start = source.index(exp.to_s(:original))
      expect(exp.ts).to eq(start),
        "expected #{exp.class} #{exp} to start at #{start}, got #{exp.ts}"

      end_idx = start + exp.base_length
      expect(exp.te).to eq(end_idx),
        "expected #{exp.class} #{exp} to end at #{end_idx}, got #{exp.te}"
    end
  end
end
