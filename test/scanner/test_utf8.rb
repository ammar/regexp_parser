require File.expand_path("../../helpers", __FILE__)

class ScannerUTF8 < Test::Unit::TestCase

  tests = {
    # 2 byte wide characters, arabic
    'aاbبcت' => {
      0     => [:literal,     :literal,       'aاbبcت',   0, 9],
    },

    'aاbبت?' => {
      0     => [:literal,     :literal,       'aاbب',     0, 6],
      1     => [:literal,     :literal,       'ت',        6, 8],
      2     => [:quantifier,  :zero_or_one,   '?',        8, 9],
    },

    'aا?bبcت+' => {
      1     => [:literal,     :literal,       'ا',        1, 3],
      2     => [:quantifier,  :zero_or_one,   '?',        3, 4],
      3     => [:literal,     :literal,       'bبc',      4, 8],
    },

    'a(اbب+)cت?' => {
      0     => [:literal,     :literal,       'a',        0, 1],
      1     => [:group,       :capture,       '(',        1, 2],
      2     => [:literal,     :literal,       'اb',       2, 5],
      3     => [:literal,     :literal,       'ب',        5, 7],
      4     => [:quantifier,  :one_or_more,   '+',        7, 8],
      5     => [:group,       :close,         ')',        8, 9],
      6     => [:literal,     :literal,       'c',        9, 10],
      7     => [:literal,     :literal,       'ت',        10, 12],
      8     => [:quantifier,  :zero_or_one,   '?',        12, 13],
    },

    # 3 byte wide characters, japanese
    'ab?れます+cd' => {
      0     => [:literal,     :literal,       'a',        0, 1],
      1     => [:literal,     :literal,       'b',        1, 2],
      2     => [:quantifier,  :zero_or_one,   '?',        2, 3],
      3     => [:literal,     :literal,       'れま',     3, 9],
      4     => [:literal,     :literal,       'す',       9, 12],
      5     => [:quantifier,  :one_or_more,   '+',        12, 13],
      6     => [:literal,     :literal,       'cd',       13, 15],
    },
  }

  count = 0
  tests.each do |pattern, checks|
    define_method "test_scan_utf8_runs_#{count+=1}" do

      tokens = RS.scan(pattern)
      checks.each do |offset, token|
        assert_equal( token, tokens[offset] )
      end

    end
  end

end
