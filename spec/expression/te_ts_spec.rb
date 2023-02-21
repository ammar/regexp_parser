require 'spec_helper'

RSpec.describe('Expression::Shared#te,ts') do
  # Many tokens/expressions have their own tests for #te and #ts.
  # This is an integration-like test to ensure they are correct in conjunction.
  it 'is correct irrespective of nesting or preceding tokens' do
    source = <<-'EOS'
      a++
      (?:
        \b {2}
        (?>
          c ??
          # 😄😄😄
          (?# 😃😃😃 )
          (
            \d *+
            (
              |
            )
          ) {004}
          |
          [
            e-f
            &&
            h
            [:ascii:]
            \p{word}
          ] {6}
          |
          \z
        )
        (?=lm{8}) ?+
        \012
        \1
        \g<-1> {10}
        \uFFFF
        no
      )
    EOS

    root = RP.parse(source, options: Regexp::EXTENDED)

    checked_exps = root.each_expression.with_object([]) do |(exp), acc|
      fail "dupe: #{exp}" if acc.any? { |e| e.to_s == exp.to_s }
      acc << exp if exp.to_s =~ /\S/
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
