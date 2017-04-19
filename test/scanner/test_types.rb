require File.expand_path("../../helpers", __FILE__)

class ScannerTypes < Test::Unit::TestCase

  tests = {
   'a\dc' => [1, :type,  :digit,       '\d',  1, 3],
   'a\Dc' => [1, :type,  :nondigit,    '\D',  1, 3],

   'a\hc' => [1, :type,  :hex,         '\h',  1, 3],
   'a\Hc' => [1, :type,  :nonhex,      '\H',  1, 3],

   'a\sc' => [1, :type,  :space,       '\s',  1, 3],
   'a\Sc' => [1, :type,  :nonspace,    '\S',  1, 3],

   'a\wc' => [1, :type,  :word,        '\w',  1, 3],
   'a\Wc' => [1, :type,  :nonword,     '\W',  1, 3],

   'a\Rc' => [1, :type,  :linebreak,   '\R',  1, 3],
   'a\Xc' => [1, :type,  :xgrapheme,   '\X',  1, 3],
  }

  tests.each do |(pattern, (index, type, token, text, ts, te))|
    define_method "test_scanner_#{type}_#{token}" do
      tokens = RS.scan(pattern)
      result = tokens.at(index)

      assert_equal type,  result[0]
      assert_equal token, result[1]
      assert_equal text,  result[2]
      assert_equal ts,    result[3]
      assert_equal te,    result[4]
    end
  end

end
