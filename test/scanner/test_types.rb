require File.expand_path("../../helpers", __FILE__)

class ScannerTypes < Test::Unit::TestCase

  tests = {
   'a\dc'       => [:type,  :digit,       '\d',  1],
   'a\Dc'       => [:type,  :nondigit,    '\D',  1],

   'a\hc'       => [:type,  :hex,         '\h',  1],
   'a\Hc'       => [:type,  :nonhex,      '\H',  1],

   'a\sc'       => [:type,  :space,       '\s',  1],
   'a\Sc'       => [:type,  :nonspace,    '\S',  1],

   'a\wc'       => [:type,  :word,        '\w',  1],
   'a\Wc'       => [:type,  :nonword,     '\W',  1],
  }

  tests.each do |pattern, test|
    [:type, :token, :text].each_with_index do |member, i|
      define_method "test_scan_#{test[0]}_#{test[1]}_#{member}" do

        token = RS.scan(pattern)[test[3]]
        assert_equal( test[i], token[i] )

      end
    end
  end

end
