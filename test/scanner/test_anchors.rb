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

  tests.each_with_index do |(pattern, (index, type, token, text, ts, te)), count|
    define_method "test_scanner_#{type}_#{token}_#{count}" do
      tokens = RS.scan(pattern)
      result = tokens[index]

      assert_equal type,  result[0]
      assert_equal token, result[1]
      assert_equal text,  result[2]
      assert_equal ts,    result[3]
      assert_equal te,    result[4]
    end
  end

end
