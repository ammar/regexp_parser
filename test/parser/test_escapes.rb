require File.expand_path("../../helpers", __FILE__)

class TestParserEscapes < Test::Unit::TestCase

  def test_parse_control_sequence_short
    #root = RP.parse(/\b\d\\\c2\C-C\M-\C-2/)
  end

  tests = {
    /a\ac/    => [1, :escape,   :bell,          EscapeSequence::Bell],
    /a\ec/    => [1, :escape,   :escape,        EscapeSequence::AsciiEscape],
    /a\fc/    => [1, :escape,   :form_feed,     EscapeSequence::FormFeed],
    /a\nc/    => [1, :escape,   :newline,       EscapeSequence::Newline],
    /a\rc/    => [1, :escape,   :carriage,      EscapeSequence::Return],
    /a\tc/    => [1, :escape,   :tab,           EscapeSequence::Tab],
    /a\vc/    => [1, :escape,   :vertical_tab,  EscapeSequence::VerticalTab],

    # special cases
    #/a\bc/    => [1, :anchor,   :word_boundary,    Anchor::WordBoundary],
    #/a\sc/    => [1, :type,     :space,            CHaracterType::Space],
  }

  count = 0
  tests.each do |pattern, test|
    define_method "test_parse_anchor_#{test[2]}_#{count+=1}" do
      root = RP.parse(pattern, 'ruby/1.9')
      exp  = root.expressions[test[0]]

      assert( exp.is_a?( test[3] ),
             "Expected #{test[3]}, but got #{exp.class.name}")

      assert_equal( test[1], exp.type )
      assert_equal( test[2], exp.token )
    end
  end

end
