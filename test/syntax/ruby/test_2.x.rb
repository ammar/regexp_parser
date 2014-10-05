require File.expand_path("../../../helpers", __FILE__)

class TestSyntaxRuby_V2x < Test::Unit::TestCase

  # Since the only Regular expression change that was introduced in ruby 2.x
  # (the conditional expressions) is not supportted yet, these tests only
  # check that the syntax files have the correct inheritance (based off the
  # last release) and load without error.

  def test_syntax_file_2_0_0
    syntax = Regexp::Syntax.new 'ruby/2.0.0'

    assert_equal( true, syntax.kind_of?(Regexp::Syntax::Ruby::V19) )
  end

  def test_syntax_file_2_0_alias
    syntax = Regexp::Syntax.new 'ruby/2.0'

    assert_equal( true, syntax.kind_of?(Regexp::Syntax::Ruby::V200) )
  end

  def test_syntax_file_2_1_0
    syntax = Regexp::Syntax.new 'ruby/2.1.0'

    assert_equal( true, syntax.kind_of?(Regexp::Syntax::Ruby::V20) )
  end

  def test_syntax_file_2_1_2
    syntax = Regexp::Syntax.new 'ruby/2.1.2'

    assert_equal( true, syntax.kind_of?(Regexp::Syntax::Ruby::V210) )
  end

  def test_syntax_file_2_1_3
    syntax = Regexp::Syntax.new 'ruby/2.1.3'

    assert_equal( true, syntax.kind_of?(Regexp::Syntax::Ruby::V212) )
  end

  def test_syntax_file_2_1_alias
    syntax = Regexp::Syntax.new 'ruby/2.1'

    assert_equal( true, syntax.kind_of?(Regexp::Syntax::Ruby::V213) )
  end

end
