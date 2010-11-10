require File.expand_path("../../helpers", __FILE__)

class TestParserAnchors < Test::Unit::TestCase

  tests = {
    '^a'      => [0, :anchor,   :beginning_of_line,   Anchor::Base],
    'a$'      => [1, :anchor,   :end_of_line,         Anchor::Base],

    '\Aa'     => [0, :anchor,   :bos,                 Anchor::Base],
    'a\z'     => [1, :anchor,   :eos,                 Anchor::Base],
    'a\Z'     => [1, :anchor,   :eos_ob_eol,          Anchor::Base],

    'a\b'     => [1, :anchor,   :word_boundary,       Anchor::Base],
    'a\B'     => [1, :anchor,   :nonword_boundary,    Anchor::Base],

    "\\\\Aa"  => [0, :escape,   :backslash,           EscapeSequence::Literal],
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
