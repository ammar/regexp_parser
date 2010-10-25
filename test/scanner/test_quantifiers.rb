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

  counter = 0
  tests.each do |pattern, test|
    name = (test[1] == :interval ? "interval_#{counter += 1}" : test[1])

    [:type, :token, :text].each_with_index do |member, i|
      define_method "test_scan_#{test[0]}_#{name}_#{member}" do

        token = RS.scan(pattern).last
        assert_equal( test[i], token[i] )

      end
    end
  end

end
