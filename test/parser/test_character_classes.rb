require File.expand_path("../../helpers", __FILE__)

class TestParserCharacterClasses < Test::Unit::TestCase
  def test_parse_character_class
    root = RP.parse('[[:word:]]')
    exp  = root[0][1]

    assert exp.is_a?(CharacterClass),
           "Expected CharacterClass, but got #{exp.class.name}"
    assert !exp.negative?

    assert_equal exp.type,  :charclass
    assert_equal exp.token, :word
    assert_equal exp.text,  'word'
  end

  def test_parse_negative_character_class
    root = RP.parse('[[:^word:]]')
    exp  = root[0][1]

    assert exp.is_a?(CharacterClass),
           "Expected CharacterClass, but got #{exp.class.name}"
    assert exp.negative?

    assert_equal exp.type,  :noncharclass
    assert_equal exp.token, :word
    assert_equal exp.text,  'word'
  end
end
