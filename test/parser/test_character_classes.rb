require File.expand_path("../../helpers", __FILE__)

class TestParserCharacterClasses < Test::Unit::TestCase
  def test_parse_character_class
    root = RP.parse('[[:word:]]')
    exp  = root[0][0]

    assert_equal CharacterClass, exp.class
    assert_equal :charclass, exp.type
    assert_equal :word, exp.token
    assert_equal 'word', exp.name
    assert_equal '[:word:]', exp.text
    refute       exp.negative?
  end

  def test_parse_negative_character_class
    root = RP.parse('[[:^word:]]')
    exp  = root[0][0]

    assert_equal CharacterClass, exp.class
    assert_equal :noncharclass, exp.type
    assert_equal :word, exp.token
    assert_equal 'word', exp.name
    assert_equal '[:^word:]', exp.text
    assert       exp.negative?
  end
end
