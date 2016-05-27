# -*- encoding: utf-8 -*-

require File.expand_path("../../helpers", __FILE__)

class LexerLiterals < Test::Unit::TestCase

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
    define_method "test_lex_literal_runs_#{count}" do
      tokens = RL.lex(pattern)

      checks.each do |index, (type, token, text, ts, te, level, set_level, conditional_level)|
        struct = tokens.at(index)

        assert_equal type,              struct.type
        assert_equal token,             struct.token
        assert_equal text,              struct.text
        assert_equal ts,                struct.ts
        assert_equal te,                struct.te
        assert_equal level,             struct.level
        assert_equal set_level,         struct.set_level
        assert_equal conditional_level, struct.conditional_level
      end
    end
  end

  def test_lex_single_2_byte_char
    tokens = RL.lex('ا+')

    assert_equal 2, tokens.length
  end

  def test_lex_single_3_byte_char
    tokens = RL.lex('れ+')

    assert_equal 2, tokens.length
  end

  def test_lex_single_4_byte_char
    tokens = RL.lex('𝄞+')

    assert_equal 2, tokens.length
  end

end
