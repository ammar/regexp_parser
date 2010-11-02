require File.expand_path("../../helpers", __FILE__)

class ScannerMeta < Test::Unit::TestCase

  tests = {
    'abc??|def*+|ghi+' => {
      3   => [:meta,    :alternation,    '|',  5,   6],
      7   => [:meta,    :alternation,    '|',  11,  12],
    },

    '(a\|b)|(c|d)\|(e[|]f)' => {
      2   => [:escape,  :alternation,    '\|', 3,   4],
      5   => [:meta,    :alternation,    '|',  6,   7],
      8   => [:meta,    :alternation,    '|',  9,   10],
      11  => [:escape,  :alternation,    '\|', 13,  14],
      15  => [:set,     :member,         '|',  17,  18],
    },
  }

  count = 0
  tests.each do |pattern, checks|
    define_method "test_scan_meta_alternation_#{count+=1}" do

      tokens = RS.scan(pattern)
      checks.each do |offset, token|
        assert_equal( token, tokens[offset] )
      end

    end
  end

end
