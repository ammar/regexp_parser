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

  tests.each_with_index do |(pattern, (index, type, token, klass)), count|
    define_method "test_parse_type_#{token}_#{count}" do
      root = RP.parse(pattern, 'ruby/1.9')
      exp  = root.expressions.at(index)

      assert exp.is_a?( klass ),
             "Expected #{klass}, but got #{exp.class.name}"

      assert_equal type,  exp.type
      assert_equal token, exp.token
    end
  end

  tests_2_0 = {
    'a\Rc'    => [1, :type,   :linebreak, CharacterType::Linebreak],
    'a\Xc'    => [1, :type,   :xgrapheme, CharacterType::ExtendedGrapheme],
  }

  tests_2_0.each_with_index do |(pattern, (index, type, token, klass)), count|
    define_method "test_parse_type_#{token}_#{count}" do
      root = RP.parse(pattern, 'ruby/2.0')
      exp  = root.expressions.at(index)

      assert exp.is_a?( klass ),
             "Expected #{klass}, but got #{exp.class.name}"

      assert_equal type,  exp.type
      assert_equal token, exp.token
    end
  end

end
