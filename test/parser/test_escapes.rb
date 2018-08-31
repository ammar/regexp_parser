require File.expand_path("../../helpers", __FILE__)

class TestParserEscapes < Test::Unit::TestCase

  tests = {
    /a\ac/    => [1, :escape,   :bell,              EscapeSequence::Bell],
    /a\ec/    => [1, :escape,   :escape,            EscapeSequence::AsciiEscape],
    /a\fc/    => [1, :escape,   :form_feed,         EscapeSequence::FormFeed],
    /a\nc/    => [1, :escape,   :newline,           EscapeSequence::Newline],
    /a\rc/    => [1, :escape,   :carriage,          EscapeSequence::Return],
    /a\tc/    => [1, :escape,   :tab,               EscapeSequence::Tab],
    /a\vc/    => [1, :escape,   :vertical_tab,      EscapeSequence::VerticalTab],

    # meta character escapes
    /a\.c/    => [1, :escape,   :dot,               EscapeSequence::Literal],
    /a\?c/    => [1, :escape,   :zero_or_one,       EscapeSequence::Literal],
    /a\*c/    => [1, :escape,   :zero_or_more,      EscapeSequence::Literal],
    /a\+c/    => [1, :escape,   :one_or_more,       EscapeSequence::Literal],
    /a\|c/    => [1, :escape,   :alternation,       EscapeSequence::Literal],
    /a\(c/    => [1, :escape,   :group_open,        EscapeSequence::Literal],
    /a\)c/    => [1, :escape,   :group_close,       EscapeSequence::Literal],
    /a\{c/    => [1, :escape,   :interval_open,     EscapeSequence::Literal],
    /a\}c/    => [1, :escape,   :interval_close,    EscapeSequence::Literal],

    # unicode escapes
    /a\u0640/       => [1, :escape, :codepoint,      EscapeSequence::Codepoint],
    /a\u{41 1F60D}/ => [1, :escape, :codepoint_list, EscapeSequence::CodepointList],
    /a\u{10FFFF}/   => [1, :escape, :codepoint_list, EscapeSequence::CodepointList],

     # hex escapes
    /a\xFF/n =>  [1, :escape, :hex,                 EscapeSequence::Hex],

    # octal escapes
    /a\177/n =>  [1, :escape, :octal,               EscapeSequence::Octal],
  }

  tests.each_with_index do |(pattern, (index, type, token, klass)), count|
    define_method "test_parse_escape_#{token}_#{count+=1}" do
      root = RP.parse(pattern, 'ruby/1.9')
      exp  = root.expressions.at(index)

      assert exp.is_a?(klass),
             "Expected #{klass}, but got #{exp.class.name}"

      assert_equal type,  exp.type
      assert_equal token, exp.token
    end
  end

  def test_parse_chars_and_codepoints
    root = RP.parse(/\n\?\101\x42\u0043\u{44 45}/)

    assert_equal "\n",       root[0].char
    assert_equal 10,         root[0].codepoint

    assert_equal "?",        root[1].char
    assert_equal 63,         root[1].codepoint

    assert_equal "A",        root[2].char
    assert_equal 65,         root[2].codepoint

    assert_equal "B",        root[3].char
    assert_equal 66,         root[3].codepoint

    assert_equal "C",        root[4].char
    assert_equal 67,         root[4].codepoint

    assert_equal ["D", "E"], root[5].chars
    assert_equal [68, 69],   root[5].codepoints
  end

  def test_parse_escape_control_sequence_lower
    root = RP.parse(/a\\\c2b/)

    assert_equal EscapeSequence::Control, root[2].class
    assert_equal '\\c2',                  root[2].text
    assert_equal "\u0012",                root[2].char
    assert_equal 18,                      root[2].codepoint
  end

  def test_parse_escape_control_sequence_upper
    root = RP.parse(/\d\\\C-C\w/)

    assert_equal EscapeSequence::Control, root[2].class
    assert_equal '\\C-C',                 root[2].text
    assert_equal "\u0003",                root[2].char
    assert_equal 3,                       root[2].codepoint
  end

  def test_parse_escape_meta_sequence
    root = RP.parse(/\Z\\\M-Z/n)

    assert_equal EscapeSequence::Meta, root[2].class
    assert_equal '\\M-Z',              root[2].text
    assert_equal "\u00DA",             root[2].char
    assert_equal 218,                  root[2].codepoint
  end

  def test_parse_escape_meta_control_sequence
    root = RP.parse(/\A\\\M-\C-X/n)

    assert_equal EscapeSequence::MetaControl, root[2].class
    assert_equal '\\M-\\C-X',                 root[2].text
    assert_equal "\u0098",                    root[2].char
    assert_equal 152,                         root[2].codepoint
  end

  def test_parse_lower_c_meta_control_sequence
    root = RP.parse(/\A\\\M-\cX/n)

    assert_equal EscapeSequence::MetaControl, root[2].class
    assert_equal '\\M-\\cX',                  root[2].text
    assert_equal "\u0098",                    root[2].char
    assert_equal 152,                         root[2].codepoint
  end

  def test_parse_escape_reverse_meta_control_sequence
    root = RP.parse(/\A\\\C-\M-X/n)

    assert_equal EscapeSequence::MetaControl, root[2].class
    assert_equal '\\C-\\M-X',                 root[2].text
    assert_equal "\u0098",                    root[2].char
    assert_equal 152,                         root[2].codepoint
  end

  def test_parse_escape_reverse_lower_c_meta_control_sequence
    root = RP.parse(/\A\\\c\M-X/n)

    assert_equal EscapeSequence::MetaControl, root[2].class
    assert_equal '\\c\\M-X',                  root[2].text
    assert_equal "\u0098",                    root[2].char
    assert_equal 152,                         root[2].codepoint
  end
end
