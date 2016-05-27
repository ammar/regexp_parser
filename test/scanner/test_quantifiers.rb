require File.expand_path("../../helpers", __FILE__)

class ScannerQuantifiers < Test::Unit::TestCase

  tests = {
   'a?'     => [:quantifier,  :zero_or_one,             '?'],
   'a??'    => [:quantifier,  :zero_or_one_reluctant,   '??'],
   'a?+'    => [:quantifier,  :zero_or_one_possessive,  '?+'],

   'a*'     => [:quantifier,  :zero_or_more,            '*'],
   'a*?'    => [:quantifier,  :zero_or_more_reluctant,  '*?'],
   'a*+'    => [:quantifier,  :zero_or_more_possessive, '*+'],

   'a+'     => [:quantifier,  :one_or_more,             '+'],
   'a+?'    => [:quantifier,  :one_or_more_reluctant,   '+?'],
   'a++'    => [:quantifier,  :one_or_more_possessive,  '++'],

   'a{2}'   => [:quantifier,  :interval,                '{2}'],
   'a{2,}'  => [:quantifier,  :interval,                '{2,}'],
   'a{,2}'  => [:quantifier,  :interval,                '{,2}'],
   'a{2,4}' => [:quantifier,  :interval,                '{2,4}'],
  }

  tests.each_with_index do |(pattern, (type, token, text)), count|
    name = (token == :interval ? "interval_#{count}" : token)

    define_method "test_scan_#{type}_#{name}" do
      tokens = RS.scan(pattern)
      result = tokens.last

      assert_equal type,  result[0]
      assert_equal token, result[1]
      assert_equal text,  result[2]
    end
  end

end
