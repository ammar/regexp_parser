require 'spec_helper'

RSpec.describe('Literal lexing') do
  tests = {
    # ascii, single byte characters
    'a' => {
      0     => [:literal,     :literal,       'a',        0, 1, 0, 0, 0],
    },

    'ab+' => {
      0     => [:literal,     :literal,       'a',        0, 1, 0, 0, 0],
      1     => [:literal,     :literal,       'b',        1, 2, 0, 0, 0],
      2     => [:quantifier,  :one_or_more,   '+',        2, 3, 0, 0, 0],
    },


    # 2 byte wide characters, Arabic
    'ا' => {
      0     => [:literal,     :literal,       'ا',        0, 2, 0, 0, 0],
    },

    'aاbبcت' => {
      0     => [:literal,     :literal,       'aاbبcت',   0, 9, 0, 0, 0],
    },

    'aاbبت?' => {
      0     => [:literal,     :literal,       'aاbب',     0, 6, 0, 0, 0],
      1     => [:literal,     :literal,       'ت',        6, 8, 0, 0, 0],
      2     => [:quantifier,  :zero_or_one,   '?',        8, 9, 0, 0, 0],
    },

    'aا?bبcت+' => {
      0     => [:literal,     :literal,       'a',        0, 1, 0, 0, 0],
      1     => [:literal,     :literal,       'ا',        1, 3, 0, 0, 0],
      2     => [:quantifier,  :zero_or_one,   '?',        3, 4, 0, 0, 0],
      3     => [:literal,     :literal,       'bبc',      4, 8, 0, 0, 0],
      4     => [:literal,     :literal,       'ت',        8, 10, 0, 0, 0],
      5     => [:quantifier,  :one_or_more,   '+',        10, 11, 0, 0, 0],
    },

    'a(اbب+)cت?' => {
      0     => [:literal,     :literal,       'a',        0, 1, 0, 0, 0],
      1     => [:group,       :capture,       '(',        1, 2, 0, 0, 0],
      2     => [:literal,     :literal,       'اb',       2, 5, 1, 0, 0],
      3     => [:literal,     :literal,       'ب',        5, 7, 1, 0, 0],
      4     => [:quantifier,  :one_or_more,   '+',        7, 8, 1, 0, 0],
      5     => [:group,       :close,         ')',        8, 9, 0, 0, 0],
      6     => [:literal,     :literal,       'c',        9, 10, 0, 0, 0],
      7     => [:literal,     :literal,       'ت',        10, 12, 0, 0, 0],
      8     => [:quantifier,  :zero_or_one,   '?',        12, 13, 0, 0, 0],
    },


    # 3 byte wide characters, Japanese
    'ab?れます+cd' => {
      0     => [:literal,     :literal,       'a',        0, 1, 0, 0, 0],
      1     => [:literal,     :literal,       'b',        1, 2, 0, 0, 0],
      2     => [:quantifier,  :zero_or_one,   '?',        2, 3, 0, 0, 0],
      3     => [:literal,     :literal,       'れま',     3, 9, 0, 0, 0],
      4     => [:literal,     :literal,       'す',       9, 12, 0, 0, 0],
      5     => [:quantifier,  :one_or_more,   '+',        12, 13, 0, 0, 0],
      6     => [:literal,     :literal,       'cd',       13, 15, 0, 0, 0],
    },


    # 4 byte wide characters, Osmanya
    '𐒀𐒁?𐒂ab+𐒃' => {
      0     => [:literal,     :literal,       '𐒀',        0, 4, 0, 0, 0],
      1     => [:literal,     :literal,       '𐒁',        4, 8, 0, 0, 0],
      2     => [:quantifier,  :zero_or_one,   '?',        8, 9, 0, 0, 0],
      3     => [:literal,     :literal,       '𐒂a',       9, 14, 0, 0, 0],
      4     => [:literal,     :literal,       'b',        14, 15, 0, 0, 0],
      5     => [:quantifier,  :one_or_more,   '+',        15, 16, 0, 0, 0],
      6     => [:literal,     :literal,       '𐒃',        16, 20, 0, 0, 0],
    },

    'mu𝄞?si*𝄫c+' => {
      0     => [:literal,     :literal,       'mu',       0, 2, 0, 0, 0],
      1     => [:literal,     :literal,       '𝄞',        2, 6, 0, 0, 0],
      2     => [:quantifier,  :zero_or_one,   '?',        6, 7, 0, 0, 0],
      3     => [:literal,     :literal,       's',        7, 8, 0, 0, 0],
      4     => [:literal,     :literal,       'i',        8, 9, 0, 0, 0],
      5     => [:quantifier,  :zero_or_more,  '*',        9, 10, 0, 0, 0],
      6     => [:literal,     :literal,       '𝄫',        10, 14, 0, 0, 0],
      7     => [:literal,     :literal,       'c',        14, 15, 0, 0, 0],
      8     => [:quantifier,  :one_or_more,   '+',        15, 16, 0, 0, 0],
    },
  }

  tests.each_with_index do |(pattern, checks), count|
    specify("lex_literal_runs_#{count}") do
      tokens = RL.lex(pattern)

      checks.each do |index, (type, token, text, ts, te, level, set_level, conditional_level)|
        struct = tokens.at(index)

        expect(struct.type).to eq type
        expect(struct.token).to eq token
        expect(struct.text).to eq text
        expect(struct.ts).to eq ts
        expect(struct.te).to eq te
        expect(struct.level).to eq level
        expect(struct.set_level).to eq set_level
        expect(struct.conditional_level).to eq conditional_level
      end
    end
  end

  specify('lex single 2 byte char') do
    tokens = RL.lex("\u0627+")

    expect(tokens.length).to eq 2
  end

  specify('lex single 3 byte char') do
    tokens = RL.lex("\u308C+")

    expect(tokens.length).to eq 2
  end

  specify('lex single 4 byte char') do
    tokens = RL.lex("\u{1D11E}+")

    expect(tokens.length).to eq 2
  end
end
