require File.expand_path("../../helpers", __FILE__)

class ScannerEscapes < Test::Unit::TestCase

  tests = {
    'c\at'          => [:escape,  :bell,          '\a',       1],
    'c\bt'          => [:escape,  :backspace,     '\b',       1],
    'c\ft'          => [:escape,  :form_feed,     '\f',       1],
    'c\nt'          => [:escape,  :newline,       '\n',       1],
    'c\tt'          => [:escape,  :tab,           '\t',       1],
    'c\vt'          => [:escape,  :vertical_tab,  '\v',       1],

    'c\qt'          => [:escape,  :literal,       '\q',       1],

    #'a\x24c'        => [:escape,  :hex,           '\x24',     2],
    #'a\x{0640}c'   => [:escape,  :hex,       '\x{0640}', 1],
    #'a\c2c'        => [:escape,  :hex,       '\c2',     1],
  }

  literal_count = 0

  tests.each do |pattern, test|
    case test[1]
    when :literal; name = "literal_#{test[2][1,1]}"
    else name = test[1]
    end

    [:type, :token, :text].each_with_index do |member, i|
      define_method "test_scan_#{test[0]}_#{name}_#{member}" do

        t = RS.scan(pattern)[test[3]]
        #puts " *** T: #{t.inspect}"

        assert_equal( test[i], t[i] )
      end
    end
  end

end
