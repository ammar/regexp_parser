# frozen_string_literal: true

require 'spec_helper'

RSpec.describe('Quantifier parsing') do
  include_examples 'parse', /a?b/,     [0, :q] => [:zero_or_one,  text: '?',     mode: :greedy,     min: 0, max: 1,  ts: 1]
  include_examples 'parse', /a??b/,    [0, :q] => [:zero_or_one,  text: '??',    mode: :reluctant,  min: 0, max: 1,  ts: 1]
  include_examples 'parse', /a?+b/,    [0, :q] => [:zero_or_one,  text: '?+',    mode: :possessive, min: 0, max: 1,  ts: 1]
  include_examples 'parse', /a*b/,     [0, :q] => [:zero_or_more, text: '*',     mode: :greedy,     min: 0, max: -1, ts: 1]
  include_examples 'parse', /a*?b/,    [0, :q] => [:zero_or_more, text: '*?',    mode: :reluctant,  min: 0, max: -1, ts: 1]
  include_examples 'parse', /a*+b/,    [0, :q] => [:zero_or_more, text: '*+',    mode: :possessive, min: 0, max: -1, ts: 1]
  include_examples 'parse', /a+b/,     [0, :q] => [:one_or_more,  text: '+',     mode: :greedy,     min: 1, max: -1, ts: 1]
  include_examples 'parse', /a+?b/,    [0, :q] => [:one_or_more,  text: '+?',    mode: :reluctant,  min: 1, max: -1, ts: 1]
  include_examples 'parse', /a++b/,    [0, :q] => [:one_or_more,  text: '++',    mode: :possessive, min: 1, max: -1, ts: 1]
  include_examples 'parse', /a{2,4}b/, [0, :q] => [:interval,     text: '{2,4}', mode: :greedy,     min: 2, max: 4,  ts: 1]
  include_examples 'parse', /a{2,}b/,  [0, :q] => [:interval,     text: '{2,}',  mode: :greedy,     min: 2, max: -1, ts: 1]
  include_examples 'parse', /a{,3}b/,  [0, :q] => [:interval,     text: '{,3}',  mode: :greedy,     min: 0, max: 3,  ts: 1]
  include_examples 'parse', /a{4}b/,   [0, :q] => [:interval,     text: '{4}',   mode: :greedy,     min: 4, max: 4,  ts: 1]
  include_examples 'parse', /a{004}b/, [0, :q] => [:interval,     text: '{004}', mode: :greedy,     min: 4, max: 4,  ts: 1]

  # special case: exps with chained quantifiers are wrapped in implicit passive groups
  include_examples 'parse', /a+{2}{3}/,
    [0]           => [:group,      :passive,     Group::Passive, implicit?: true, level: 0],
    [0, :q]       => [:quantifier, :interval,    Quantifier,     text: '{3}',     level: 0],
    [0, 0]        => [:group,      :passive,     Group::Passive, implicit?: true, level: 1],
    [0, 0, :q]    => [:quantifier, :interval,    Quantifier,     text: '{2}',     level: 1],
    [0, 0, 0]     => [:literal,    :literal,     Literal,        text: 'a',       level: 2],
    [0, 0, 0, :q] => [:quantifier, :one_or_more, Quantifier,     text: '+',       level: 2]

  # Ruby does not support modes for intervals, following `?` and `+` are read as chained quantifiers
  include_examples 'parse', /a{2,4}?b/,
    [0, :q]    => [:quantifier, :zero_or_one, Quantifier, text: '?',     mode: :greedy, min: 0, max: 1, ts: 6],
    [0, 0, :q] => [:quantifier, :interval,    Quantifier, text: '{2,4}', mode: :greedy, min: 2, max: 4, ts: 1]
  include_examples 'parse', /a{2,4}+b/,
    [0, :q]    => [:quantifier, :one_or_more, Quantifier, text: '+',     mode: :greedy, min: 1, max: -1, ts: 6],
    [0, 0, :q] => [:quantifier, :interval,    Quantifier, text: '{2,4}', mode: :greedy, min: 2, max: 4,  ts: 1]

  specify('mode-checking methods') do
    exp = RP.parse(/a??/).first

    expect(exp).to be_reluctant
    expect(exp).to be_lazy
    expect(exp).not_to be_greedy
    expect(exp).not_to be_possessive
    expect(exp.quantifier).to be_reluctant
    expect(exp.quantifier).to be_lazy
    expect(exp.quantifier).not_to be_greedy
    expect(exp.quantifier).not_to be_possessive
  end
end
