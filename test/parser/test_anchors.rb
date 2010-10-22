require File.expand_path("../../helpers", __FILE__)

class TestRegexpParserAnchors < Test::Unit::TestCase

  tests = {
   '^a'   => [:beginning_of_line, :first],
   'a$'   => [:end_of_line,       :last],

   '\Aa'  => [:bos,               :first],
   'a\z'  => [:eos,               :last],
   'a\Z'  => [:eos_or_before_eol, :last],

   'a\b'  => [:word_boundary,     :last],
   'a\B'  => [:nonword_boundary,  :last],
  }

  tests.each do |pattern, args|
    define_method "test_parse_anchor_#{args.first}" do
      t = RP.parse(pattern)

      assert( t.expressions.send(args.last).is_a?(RP::Expression::Anchor),
             "Expected anchor, but got #{t.expressions.send(args.last).class.name}")

      assert_equal( :anchor,    t.expressions.send(args.last).type )
      assert_equal( args.first, t.expressions.send(args.last).token )
    end
  end

end
