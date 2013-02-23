require File.expand_path("../../helpers", __FILE__)

class ScannerAnchors < Test::Unit::TestCase

  tests = {
   '^abc'       => [0, :anchor,     :bol,                   '^',    0, 1],
   'abc$'       => [1, :anchor,     :eol,                   '$',    3, 4],

   '\Aabc'      => [0, :anchor,     :bos,                   '\A',   0, 2],
   'abc\z'      => [1, :anchor,     :eos,                   '\z',   3, 5],
   'abc\Z'      => [1, :anchor,     :eos_ob_eol,            '\Z',   3, 5],

   'a\bc'       => [1, :anchor,     :word_boundary,         '\b',   1, 3],
   'a\Bc'       => [1, :anchor,     :nonword_boundary,      '\B',   1, 3],

   'a\Gc'       => [1, :anchor,     :match_start,           '\G',   1, 3],

   "\\\\Ac"     => [0, :escape,    :backslash,              '\\\\', 0, 2],
   "a\\\\z"     => [1, :escape,    :backslash,              '\\\\', 1, 3],
   "a\\\\Z"     => [1, :escape,    :backslash,              '\\\\', 1, 3],
   "a\\\\bc"    => [1, :escape,    :backslash,              '\\\\', 1, 3],
   "a\\\\Bc"    => [1, :escape,    :backslash,              '\\\\', 1, 3],
  }

  count = 0
  tests.each do |pattern, test|
    define_method "test_scanner_#{test[1]}_#{test[2]}_#{count+=1}" do

      tokens = RS.scan(pattern)
      assert_equal( test[1,5], tokens[test[0]] )

    end
  end

end
