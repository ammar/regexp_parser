require File.expand_path("../../helpers", __FILE__)

class ScannerAnchors < Test::Unit::TestCase

  tests = {
   '^abc'       => [:anchor,     :beginning_of_line,    '^',   0],
   'abc$'       => [:anchor,     :end_of_line,          '$',   1],

   '\Aabc'      => [:anchor,     :bos,                  '\A',  0],
   'abc\z'      => [:anchor,     :eos,                  '\z',  1],
   'abc\Z'      => [:anchor,     :eos_ob_eol,           '\Z',  1],

   'a\bc'       => [:anchor,     :word_boundary,        '\b',  1],
   'a\Bc'       => [:anchor,     :nonword_boundary,     '\B',  1],
  }

  tests.each do |pattern, test|
    [:type, :token, :text].each_with_index do |member, i|
      define_method "test_scanner_#{test[0]}_#{test[1]}_#{member}" do

        tokens = RS.scan(pattern)
        assert_equal( test[i], tokens[test[3]][i] )

      end
    end
  end

end
