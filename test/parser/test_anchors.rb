require File.expand_path("../../helpers", __FILE__)

class TestRegexpParserAnchors < Test::Unit::TestCase

  tests = {
    :beginning_of_line    => ['^a', :first],
    :end_of_line          => ['a$', :last],

    :bos                  => ['\Aa', :first],
    :eos                  => ['a\z', :last],
    :eos_or_before_eol    => ['a\Z', :last],

    :word_boundary        => ['a\b', :last],
    :non_word_boundary    => ['a\B', :last],
  }

  tests.each do |token, args|
    define_method "test_parse_anchor_#{token}" do
      t = RP.parse(args.first)

      assert( t.expressions.send(args.last).is_a?(RP::Expression::Anchor),
             "Expected anchor, but got #{t.expressions.send(args.last).class.name}")

      assert_equal( :anchor,  t.expressions.send(args.last).type )
      assert_equal( token,    t.expressions.send(args.last).token )
    end
  end

end
