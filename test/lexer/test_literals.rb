require File.expand_path("../../helpers", __FILE__)

class LexerLiterals < Test::Unit::TestCase

  tests = {
    # 2 byte wide characters, Arabic
    'aاbبcت' => {
      0     => [:literal,     :literal,       'aاbبcت',   0, 9, 0],
    },

    'aاbبت?' => {
      0     => [:literal,     :literal,       'aاbب',     0, 6, 0],
      1     => [:literal,     :literal,       'ت',        6, 8, 0],
      2     => [:quantifier,  :zero_or_one,   '?',        8, 9, 0],
    },

    'aا?bبcت+' => {
      0     => [:literal,     :literal,       'a',        0, 1, 0],
      1     => [:literal,     :literal,       'ا',        1, 3, 0],
      2     => [:quantifier,  :zero_or_one,   '?',        3, 4, 0],
      3     => [:literal,     :literal,       'bبc',      4, 8, 0],
      4     => [:literal,     :literal,       'ت',        8, 10, 0],
      5     => [:quantifier,  :one_or_more,   '+',        10, 11, 0],
    },

    'a(اbب+)cت?' => {
      0     => [:literal,     :literal,       'a',        0, 1, 0],
      1     => [:group,       :capture,       '(',        1, 2, 0],
      2     => [:literal,     :literal,       'اb',       2, 5, 1],
      3     => [:literal,     :literal,       'ب',        5, 7, 1],
      4     => [:quantifier,  :one_or_more,   '+',        7, 8, 1],
      5     => [:group,       :close,         ')',        8, 9, 0],
      6     => [:literal,     :literal,       'c',        9, 10, 0],
      7     => [:literal,     :literal,       'ت',        10, 12, 0],
      8     => [:quantifier,  :zero_or_one,   '?',        12, 13, 0],
    },

    # 3 byte wide characters, Japanese
    'ab?れます+cd' => {
      0     => [:literal,     :literal,       'a',        0, 1, 0],
      1     => [:literal,     :literal,       'b',        1, 2, 0],
      2     => [:quantifier,  :zero_or_one,   '?',        2, 3, 0],
      3     => [:literal,     :literal,       'れま',     3, 9, 0],
      4     => [:literal,     :literal,       'す',       9, 12, 0],
      5     => [:quantifier,  :one_or_more,   '+',        12, 13, 0],
      6     => [:literal,     :literal,       'cd',       13, 15, 0],
    },

    # 4 byte wide characters, Osmanya
    '𐒀𐒁?𐒂ab+𐒃' => {
      0     => [:literal,     :literal,       '𐒀',        0, 4, 0],
      1     => [:literal,     :literal,       '𐒁',        4, 8, 0],
      2     => [:quantifier,  :zero_or_one,   '?',        8, 9, 0],
      3     => [:literal,     :literal,       '𐒂a',       9, 14, 0],
      4     => [:literal,     :literal,       'b',        14, 15, 0],
      5     => [:quantifier,  :one_or_more,   '+',        15, 16, 0],
      6     => [:literal,     :literal,       '𐒃',        16, 20, 0],
    },

    'mu𝄞?si*𝄫c+' => {
      0     => [:literal,     :literal,       'mu',       0, 2, 0],
      1     => [:literal,     :literal,       '𝄞',        2, 6, 0],
      2     => [:quantifier,  :zero_or_one,   '?',        6, 7, 0],
      3     => [:literal,     :literal,       's',        7, 8, 0],
      4     => [:literal,     :literal,       'i',        8, 9, 0],
      5     => [:quantifier,  :zero_or_more,  '*',        9, 10, 0],
      6     => [:literal,     :literal,       '𝄫',        10, 14, 0],
      7     => [:literal,     :literal,       'c',        14, 15, 0],
      8     => [:quantifier,  :one_or_more,   '+',        15, 16, 0],
    },
  }

  count = 0
  tests.each do |pattern, checks|
    define_method "test_lex_literal_runs_#{count+=1}" do

      tokens = RL.scan(pattern)
      checks.each do |offset, token|
        assert_equal( token, tokens[offset].to_a )
      end

    end
  end

end
