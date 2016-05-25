require File.expand_path("../../helpers", __FILE__)

class TestParserTypes < Test::Unit::TestCase

  tests = {
    /a\dc/    => [1, :type,   :digit,     CharacterType::Digit],
    /a\Dc/    => [1, :type,   :nondigit,  CharacterType::NonDigit],

    /a\sc/    => [1, :type,   :space,     CharacterType::Space],
    /a\Sc/    => [1, :type,   :nonspace,  CharacterType::NonSpace],

    /a\hc/    => [1, :type,   :hex,       CharacterType::Hex],
    /a\Hc/    => [1, :type,   :nonhex,    CharacterType::NonHex],

    /a\wc/    => [1, :type,   :word,      CharacterType::Word],
    /a\Wc/    => [1, :type,   :nonword,   CharacterType::NonWord],
  }

  count = 0
  tests.each do |pattern, test|
    define_method "test_parse_type_#{test[2]}_#{count+=1}" do
      root = RP.parse(pattern, 'ruby/1.9')
      exp  = root.expressions[test[0]]

      assert( exp.is_a?( test[3] ),
             "Expected #{test[3]}, but got #{exp.class.name}")

      assert_equal( test[1], exp.type )
      assert_equal( test[2], exp.token )
    end
  end

end
