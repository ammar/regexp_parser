require File.expand_path("../../helpers", __FILE__)

class TestParserAnchors < Test::Unit::TestCase

  tests = {
    '^a'      => [0, :anchor,   :bol,                 Anchor::BOL],
    'a$'      => [1, :anchor,   :eol,                 Anchor::EOL],

    '\Aa'     => [0, :anchor,   :bos,                 Anchor::BOS],
    'a\z'     => [1, :anchor,   :eos,                 Anchor::EOS],
    'a\Z'     => [1, :anchor,   :eos_ob_eol,          Anchor::EOSobEOL],

    'a\b'     => [1, :anchor,   :word_boundary,       Anchor::WordBoundary],
    'a\B'     => [1, :anchor,   :nonword_boundary,    Anchor::NonWordBoundary],

    'a\G'     => [1, :anchor,   :match_start,         Anchor::MatchStart],

    "\\\\Aa"  => [0, :escape,   :backslash,           EscapeSequence::Literal],
  }

  tests.each_with_index do |(pattern, (index, type, token, klass)), count|
    define_method "test_parse_anchor_#{token}_#{count}" do
      root = RP.parse(pattern, 'ruby/1.9')
      exp  = root.expressions.at(index)

      assert exp.is_a?(klass),
             "Expected #{klass}, but got #{exp.class.name}"

      assert_equal type,  exp.type
      assert_equal token, exp.token
    end
  end

end
