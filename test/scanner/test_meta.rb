require File.expand_path("../../helpers", __FILE__)

class ScannerMeta < Test::Unit::TestCase

  tests = {
    'abc??|def*+|ghi+' => {
      0   => [:literal,     :literal,                 'abc',  0, 3],
      1   => [:quantifier,  :zero_or_one_reluctant,   '??',   3, 5],
      2   => [:meta,        :alternation,             '|',    5, 6],
      3   => [:literal,     :literal,                 'def',  6, 9],
      4   => [:quantifier,  :zero_or_more_possessive, '*+',   9, 11],
      5   => [:meta,        :alternation,             '|',    11, 12],
    },

    '(a\|b)|(c|d)\|(e[|]f)' => {
      2   => [:escape,      :alternation,             '\|',   2, 4],
      5   => [:meta,        :alternation,             '|',    6, 7],
      8   => [:meta,        :alternation,             '|',    9, 10],
      11  => [:escape,      :alternation,             '\|',   12, 14],
      15  => [:literal,     :literal,                 '|',    17, 18],
    },
  }

  tests.each_with_index do |(pattern, checks), count|
    define_method "test_scanner_meta_alternation_#{count}" do
      tokens = RS.scan(pattern)

      checks.each do |index, (type, token, text, ts, te)|
        result = tokens.at(index)

        assert_equal type,  result[0]
        assert_equal token, result[1]
        assert_equal text,  result[2]
        assert_equal ts,    result[3]
        assert_equal te,    result[4]
      end
    end
  end

end
