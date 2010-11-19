require File.expand_path("../../helpers", __FILE__)

class TestParserSets < Test::Unit::TestCase

  def test_parse_set_basic
    exp = RP.parse('[a-c]+', :any).expressions[0]

    assert_equal( true, exp.is_a?(CharacterSet) )
    assert_equal( true, exp.include?('a-c') )

    assert_equal( true, exp.quantified? )
    assert_equal( 1,  exp.quantifier.min )
    assert_equal( -1, exp.quantifier.max )
  end

  def test_parse_set_posix_class
    exp = RP.parse('[[:digit:][:lower:]]+', 'ruby/1.9').expressions[0]

    assert_equal( true,  exp.is_a?(CharacterSet) )

    assert_equal( true,  exp.include?('[:digit:]') )
    assert_equal( true,  exp.include?('[:lower:]') )

    assert_equal( true,  exp.matches?("6") )

    # TODO: figure out why this generate wrong string, but only after
    # the assertion above (to_s "piles up")
    #assert_equal( true,  exp.matches?("v") )
    #assert_equal( false, exp.matches?("\x48") )
  end

  def test_parse_set_members
    exp = RP.parse('[ac-eh]', :any)[0]

    assert_equal( true,  exp.include?('a') )
    assert_equal( true,  exp.include?('c-e') )
    assert_equal( true,  exp.include?('h') )
    assert_equal( false, exp.include?(']') )
  end

  def test_parse_set_collating_sequence
    exp = RP.parse('[a[.span-ll.]h]', :any)[0]

    assert_equal( true,  exp.include?('[.span-ll.]') )
    assert_equal( false, exp.include?(']') )
  end

  def test_parse_set_character_equivalents
    exp = RP.parse('[a[=e=]h]', :any)[0]

    assert_equal( true,  exp.include?('[=e=]') )
    assert_equal( false, exp.include?(']') )
  end

  def test_parse_set_nesting_tos
    pattern = '[a[b[^c]]]'

    assert_equal( pattern, RP.parse(pattern, 'ruby/1.9').to_s )
  end

  def test_parse_set_nesting_include
    exp = RP.parse('[a[b[^c]]]', 'ruby/1.9')[0]

    assert_equal( true, exp.is_a?(CharacterSet) )
    assert_equal( true, exp.include?('a') )
    assert_equal( true, exp.include?('b') )
    assert_equal( true, exp.include?('c') )
  end

  # character subsets and negated posix classes are not available in ruby 1.8
  if RUBY_VERSION >= '1.9'
    def test_parse_set_nesting_matches
      exp = RP.parse('[a[b[^c]]]', 'ruby/1.9')[0]

      assert_equal( true,  exp.matches?("b") )

      # TODO: figure out why this generate wrong string, but only after
      # the assertion above (to_s "piles up")
      #assert_equal( false, exp.matches?("c") )
    end

    def test_parse_set_nesting_not_matches
      exp = RP.parse('[a[b[^c]]]', 'ruby/1.9')[0]
      assert_equal( false, exp.matches?("c") )
    end

    def test_parse_set_negated_posix_class
      exp = RP.parse('[[:^xdigit:][:^lower:]]+', 'ruby/1.9').expressions[0]

      assert_equal( true,  exp.is_a?(CharacterSet) )

      assert_equal( true,  exp.include?('[:^xdigit:]') )
      assert_equal( true,  exp.include?('[:^lower:]') )

      assert_equal( true,  exp.matches?("GT") )
    end
  end

end
