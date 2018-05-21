require File.expand_path("../../helpers", __FILE__)

class TestParserSets < Test::Unit::TestCase
  def test_parse_set_basic
    root = RP.parse('[ab]+')
    exp  = root[0]

    assert_equal CharacterSet, exp.class
    assert_equal 2, exp.count

    assert_equal Literal, exp[0].class
    assert_equal 'a', exp[0].text
    assert_equal Literal, exp[1].class
    assert_equal 'b', exp[1].text

    assert       exp.quantified?
    assert_equal 1, exp.quantifier.min
    assert_equal(-1, exp.quantifier.max)
  end

  def test_parse_set_char_type
    root = RP.parse('[a\dc]')
    exp  = root[0]

    assert_equal CharacterSet, exp.class
    assert_equal 3, exp.count

    assert_equal CharacterType::Digit, exp[1].class
    assert_equal '\d', exp[1].text
  end

  def test_parse_set_escape_sequence_backspace
    root = RP.parse('[a\bc]')
    exp  = root[0]

    assert_equal CharacterSet, exp.class
    assert_equal 3, exp.count

    assert_equal EscapeSequence::Backspace, exp[1].class
    assert_equal '\b', exp[1].text

    assert       exp.matches?('a')
    assert       exp.matches?("\b")
    refute       exp.matches?('b')
    assert       exp.matches?('c')
  end

  def test_parse_set_escape_sequence_hex
    root = RP.parse('[a\x20c]', :any)
    exp  = root[0]

    assert_equal CharacterSet, exp.class
    assert_equal 3, exp.count

    assert_equal EscapeSequence::Hex, exp[1].class
    assert_equal '\x20', exp[1].text
  end

  def test_parse_set_escape_sequence_codepoint
    root = RP.parse('[a\u0640]')
    exp  = root[0]

    assert_equal CharacterSet, exp.class
    assert_equal 2, exp.count

    assert_equal EscapeSequence::Codepoint, exp[1].class
    assert_equal '\u0640', exp[1].text
  end

  def test_parse_set_escape_sequence_codepoint_list
    root = RP.parse('[a\u{41 1F60D}]')
    exp  = root[0]

    assert_equal CharacterSet, exp.class
    assert_equal 2, exp.count

    assert_equal EscapeSequence::CodepointList, exp[1].class
    assert_equal '\u{41 1F60D}', exp[1].text
  end

  def test_parse_set_posix_class
    root = RP.parse('[[:digit:][:^lower:]]+')
    exp  = root[0]

    assert_equal CharacterSet, exp.class
    assert_equal 2, exp.count

    assert_equal PosixClass, exp[0].class
    assert_equal '[:digit:]', exp[0].text
    assert_equal PosixClass, exp[1].class
    assert_equal '[:^lower:]', exp[1].text
  end

  def test_parse_set_nesting
    root = RP.parse('[a[b[c]d]e]')

    exp = root[0]
    assert_equal CharacterSet, exp.class
    assert_equal 3, exp.count
    assert_equal Literal, exp[0].class
    assert_equal Literal, exp[2].class

    subset1 = exp[1]
    assert_equal CharacterSet, subset1.class
    assert_equal 3, subset1.count
    assert_equal Literal, subset1[0].class
    assert_equal Literal, subset1[2].class

    subset2 = subset1[1]
    assert_equal CharacterSet, subset2.class
    assert_equal 1, subset2.count
    assert_equal Literal, subset2[0].class
  end

  def test_parse_set_nesting_negative
    root = RP.parse('[a[^b[c]]]')
    exp  = root[0]

    assert_equal CharacterSet, exp.class
    assert_equal 2, exp.count
    assert_equal Literal, exp[0].class
    refute       exp.negative?

    subset1 = exp[1]
    assert_equal CharacterSet, subset1.class
    assert_equal 2, subset1.count
    assert_equal Literal, subset1[0].class
    assert       subset1.negative?

    subset2 = subset1[1]
    assert_equal CharacterSet, subset2.class
    assert_equal 1, subset2.count
    assert_equal Literal, subset2[0].class
    refute       subset2.negative?
  end

  def test_parse_set_nesting_to_s
    pattern = '[a[b[^c]]]'
    root    = RP.parse(pattern)

    assert_equal pattern, root.to_s
  end

  def test_parse_set_literals_are_not_merged
    root = RP.parse("[#{'a' * 10}]")
    exp  = root[0]

    assert_equal 10, exp.count
  end

  def test_parse_set_whitespace_is_not_merged
    root = RP.parse("[#{' ' * 10}]")
    exp  = root[0]

    assert_equal 10, exp.count
  end

  def test_parse_set_whitespace_is_not_merged_in_x_mode
    root = RP.parse("(?x)[#{' ' * 10}]")
    exp  = root[1]

    assert_equal 10, exp.count
  end

  # TODO: Collations and equivalents need own exp class if they ever get enabled
  def test_parse_set_collating_sequence
    root = RP.parse('[a[.span-ll.]h]', :any)
    exp  = root[0]

    assert_equal '[.span-ll.]', exp[1].to_s
  end

  def test_parse_set_character_equivalents
    root = RP.parse('[a[=e=]h]', :any)
    exp  = root[0]

    assert_equal '[=e=]', exp[1].to_s
  end
end
