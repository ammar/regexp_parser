require File.expand_path("../../helpers", __FILE__)

class ScannerSets < Test::Unit::TestCase

  tests = {
    '[a]'             => [:set,  :open,         '[',    0],
    '[b]'             => [:set,  :close,        ']',    2],
    '[^n]'            => [:set,  :negate,       '^',    1],

    '[c]'             => [:set,  :member,       'c',    1],
    '[\b]'            => [:set,  :backspace,    '\b',   1],

    '[\]]'            => [:set,  :escape,       '\]',   1],
    '[\\\]'           => [:set,  :escape,       '\\\\', 1],
    '[a\-c]'          => [:set,  :escape,       '\-',   2],

    '[\d]'            => [:set,  :type_digit,     '\d', 1],
    '[\D]'            => [:set,  :type_nondigit,  '\D', 1],

    '[\h]'            => [:set,  :type_hex,       '\h', 1],
    '[\H]'            => [:set,  :type_nonhex,    '\H', 1],

    '[\s]'            => [:set,  :type_space,     '\s', 1],
    '[\S]'            => [:set,  :type_nonspace,  '\S', 1],

    '[\w]'            => [:set,  :type_word,      '\w', 1],
    '[\W]'            => [:set,  :type_nonword,   '\W', 1],

    '[a-c]'           => [:set,  :range,          'a-c', 1],
    '[a-c-]'          => [:set,  :member,         '-',   2],
    '[a-c^]'          => [:set,  :member,         '^',   2],
    '[a-cd-f]'        => [:set,  :range,          'd-f', 2],

    '[a-d&&g-h]'      => [:set,  :intersection,   '&&', 2],

    '[\\x20-\\x28]'   => [:set,  :range_hex,      '\x20-\x28', 1],
  }

  member_count = 0
  escape_count = 0
  range_count = 0

  tests.each do |pattern, test|
    case test[1]
    when :member; name = "member_#{member_count += 1}"
    when :escape; name = "escape_#{escape_count += 1}"
    when :range;  name = "range_#{range_count += 1}"
    else name = test[1]
    end

    [:type, :token, :text].each_with_index do |member, i|
      define_method "test_scan_#{test[0]}_#{name}_#{member}" do

        token = RS.scan(pattern)[test[3]]
        assert_equal( test[i], token[i] )

      end
    end
  end

end
