require File.expand_path("../../helpers", __FILE__)

class ScannerUTF8 < Test::Unit::TestCase

  tests = {
   'aاbبcت'  => [:literal,  :literal,   'ب',  3],
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
