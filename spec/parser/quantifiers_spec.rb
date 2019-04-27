require 'spec_helper'

RSpec.describe('Quantifier parsing') do
  specify('parse zero or one greedy') do
    root = RP.parse('a?bc')
    exp = root.expressions.first

    expect(exp).to be_quantified
    expect(exp.quantifier.token).to eq :zero_or_one
    expect(exp.quantifier.min).to eq 0
    expect(exp.quantifier.max).to eq 1
    expect(exp.quantifier.mode).to eq :greedy
    expect(exp.quantifier).to be_greedy
    expect(exp).to be_greedy

    expect(exp.quantifier).not_to be_reluctant
    expect(exp).not_to be_reluctant
    expect(exp.quantifier).not_to be_possessive
    expect(exp).not_to be_possessive
  end

  specify('parse zero or one reluctant') do
    root = RP.parse('a??bc')
    exp = root.expressions.first

    expect(exp).to be_quantified
    expect(exp.quantifier.token).to eq :zero_or_one
    expect(exp.quantifier.min).to eq 0
    expect(exp.quantifier.max).to eq 1
    expect(exp.quantifier.mode).to eq :reluctant
    expect(exp.quantifier).to be_reluctant
    expect(exp).to be_reluctant

    expect(exp.quantifier).not_to be_greedy
    expect(exp).not_to be_greedy
    expect(exp.quantifier).not_to be_possessive
    expect(exp).not_to be_possessive
  end

  specify('parse zero or one possessive') do
    root = RP.parse('a?+bc', 'ruby/1.9')
    exp = root.expressions.first

    expect(exp).to be_quantified
    expect(exp.quantifier.token).to eq :zero_or_one
    expect(exp.quantifier.min).to eq 0
    expect(exp.quantifier.max).to eq 1
    expect(exp.quantifier.mode).to eq :possessive
    expect(exp.quantifier).to be_possessive
    expect(exp).to be_possessive

    expect(exp.quantifier).not_to be_greedy
    expect(exp).not_to be_greedy
    expect(exp.quantifier).not_to be_reluctant
    expect(exp).not_to be_reluctant
  end

  specify('parse zero or more greedy') do
    root = RP.parse('a*bc')
    exp = root.expressions.first

    expect(exp).to be_quantified
    expect(exp.quantifier.token).to eq :zero_or_more
    expect(exp.quantifier.min).to eq 0
    expect(exp.quantifier.max).to eq(-1)
    expect(exp.quantifier.mode).to eq :greedy
    expect(exp.quantifier).to be_greedy
    expect(exp).to be_greedy
  end

  specify('parse zero or more reluctant') do
    root = RP.parse('a*?bc')
    exp = root.expressions.first

    expect(exp).to be_quantified
    expect(exp.quantifier.token).to eq :zero_or_more
    expect(exp.quantifier.min).to eq 0
    expect(exp.quantifier.max).to eq(-1)
    expect(exp.quantifier.mode).to eq :reluctant
    expect(exp.quantifier).to be_reluctant
    expect(exp).to be_reluctant
  end

  specify('parse zero or more possessive') do
    root = RP.parse('a*+bc', 'ruby/1.9')
    exp = root.expressions.first

    expect(exp).to be_quantified
    expect(exp.quantifier.token).to eq :zero_or_more
    expect(exp.quantifier.min).to eq 0
    expect(exp.quantifier.max).to eq(-1)
    expect(exp.quantifier.mode).to eq :possessive
    expect(exp.quantifier).to be_possessive
    expect(exp).to be_possessive
  end

  specify('parse one or more greedy') do
    root = RP.parse('a+bc')
    exp = root.expressions.first

    expect(exp).to be_quantified
    expect(exp.quantifier.token).to eq :one_or_more
    expect(exp.quantifier.min).to eq 1
    expect(exp.quantifier.max).to eq(-1)
    expect(exp.quantifier.mode).to eq :greedy
    expect(exp.quantifier).to be_greedy
    expect(exp).to be_greedy
  end

  specify('parse one or more reluctant') do
    root = RP.parse('a+?bc')
    exp = root.expressions.first

    expect(exp).to be_quantified
    expect(exp.quantifier.token).to eq :one_or_more
    expect(exp.quantifier.min).to eq 1
    expect(exp.quantifier.max).to eq(-1)
    expect(exp.quantifier.mode).to eq :reluctant
    expect(exp.quantifier).to be_reluctant
    expect(exp).to be_reluctant
  end

  specify('parse one or more possessive') do
    root = RP.parse('a++bc', 'ruby/1.9')
    exp = root.expressions.first

    expect(exp).to be_quantified
    expect(exp.quantifier.token).to eq :one_or_more
    expect(exp.quantifier.min).to eq 1
    expect(exp.quantifier.max).to eq(-1)
    expect(exp.quantifier.mode).to eq :possessive
    expect(exp.quantifier).to be_possessive
    expect(exp).to be_possessive
  end

  specify('parse intervals min max greedy') do
    root = RP.parse('a{2,4}bc')
    exp = root.expressions.first

    expect(exp).to be_quantified
    expect(exp.quantifier.token).to eq :interval
    expect(exp.quantifier.min).to eq 2
    expect(exp.quantifier.max).to eq 4
    expect(exp.quantifier.mode).to eq :greedy
    expect(exp.quantifier).to be_greedy
    expect(exp).to be_greedy
  end

  specify('parse intervals min max reluctant') do
    root = RP.parse('a{3,5}?bc')
    exp = root.expressions.first

    expect(exp).to be_quantified
    expect(exp.quantifier.token).to eq :interval
    expect(exp.quantifier.min).to eq 3
    expect(exp.quantifier.max).to eq 5
    expect(exp.quantifier.mode).to eq :reluctant
    expect(exp.quantifier).to be_reluctant
    expect(exp).to be_reluctant
  end

  specify('parse intervals min max possessive') do
    root = RP.parse('a{2,4}+bc', 'ruby/1.9')
    exp = root.expressions.first

    expect(exp).to be_quantified
    expect(exp.quantifier.token).to eq :interval
    expect(exp.quantifier.min).to eq 2
    expect(exp.quantifier.max).to eq 4
    expect(exp.quantifier.mode).to eq :possessive
    expect(exp.quantifier).to be_possessive
    expect(exp).to be_possessive
  end

  specify('parse intervals min only greedy') do
    root = RP.parse('a{2,}bc')
    exp = root.expressions.first

    expect(exp).to be_quantified
    expect(exp.quantifier.token).to eq :interval
    expect(exp.quantifier.min).to eq 2
    expect(exp.quantifier.max).to eq(-1)
    expect(exp.quantifier.mode).to eq :greedy
    expect(exp.quantifier).to be_greedy
    expect(exp).to be_greedy
  end

  specify('parse intervals min only reluctant') do
    root = RP.parse('a{2,}?bc')
    exp = root.expressions.first

    expect(exp).to be_quantified
    expect(exp.quantifier.token).to eq :interval
    expect(exp.quantifier.text).to eq '{2,}?'
    expect(exp.quantifier.min).to eq 2
    expect(exp.quantifier.max).to eq(-1)
    expect(exp.quantifier.mode).to eq :reluctant
    expect(exp.quantifier).to be_reluctant
    expect(exp).to be_reluctant
  end

  specify('parse intervals min only possessive') do
    root = RP.parse('a{3,}+bc', 'ruby/1.9')
    exp = root.expressions.first

    expect(exp).to be_quantified
    expect(exp.quantifier.token).to eq :interval
    expect(exp.quantifier.text).to eq '{3,}+'
    expect(exp.quantifier.min).to eq 3
    expect(exp.quantifier.max).to eq(-1)
    expect(exp.quantifier.mode).to eq :possessive
    expect(exp.quantifier).to be_possessive
    expect(exp).to be_possessive
  end

  specify('parse intervals max only greedy') do
    root = RP.parse('a{,2}bc')
    exp = root.expressions.first

    expect(exp).to be_quantified
    expect(exp.quantifier.token).to eq :interval
    expect(exp.quantifier.min).to eq 0
    expect(exp.quantifier.max).to eq 2
    expect(exp.quantifier.mode).to eq :greedy
    expect(exp.quantifier).to be_greedy
    expect(exp).to be_greedy
  end

  specify('parse intervals max only reluctant') do
    root = RP.parse('a{,4}?bc')
    exp = root.expressions.first

    expect(exp).to be_quantified
    expect(exp.quantifier.token).to eq :interval
    expect(exp.quantifier.min).to eq 0
    expect(exp.quantifier.max).to eq 4
    expect(exp.quantifier.mode).to eq :reluctant
    expect(exp.quantifier).to be_reluctant
    expect(exp).to be_reluctant
  end

  specify('parse intervals max only possessive') do
    root = RP.parse('a{,3}+bc', 'ruby/1.9')
    exp = root.expressions.first

    expect(exp).to be_quantified
    expect(exp.quantifier.token).to eq :interval
    expect(exp.quantifier.min).to eq 0
    expect(exp.quantifier.max).to eq 3
    expect(exp.quantifier.mode).to eq :possessive
    expect(exp.quantifier).to be_possessive
    expect(exp).to be_possessive
  end

  specify('parse intervals exact greedy') do
    root = RP.parse('a{2}bc')
    exp = root.expressions.first

    expect(exp).to be_quantified
    expect(exp.quantifier.token).to eq :interval
    expect(exp.quantifier.min).to eq 2
    expect(exp.quantifier.max).to eq 2
    expect(exp.quantifier.mode).to eq :greedy
    expect(exp.quantifier).to be_greedy
    expect(exp).to be_greedy
  end

  specify('parse intervals exact reluctant') do
    root = RP.parse('a{3}?bc')
    exp = root.expressions.first

    expect(exp).to be_quantified
    expect(exp.quantifier.token).to eq :interval
    expect(exp.quantifier.min).to eq 3
    expect(exp.quantifier.max).to eq 3
    expect(exp.quantifier.mode).to eq :reluctant
    expect(exp.quantifier).to be_reluctant
    expect(exp).to be_reluctant
  end

  specify('parse intervals exact possessive') do
    root = RP.parse('a{3}+bc', 'ruby/1.9')
    exp = root.expressions.first

    expect(exp).to be_quantified
    expect(exp.quantifier.token).to eq :interval
    expect(exp.quantifier.min).to eq 3
    expect(exp.quantifier.max).to eq 3
    expect(exp.quantifier.mode).to eq :possessive
    expect(exp.quantifier).to be_possessive
    expect(exp).to be_possessive
  end
end
