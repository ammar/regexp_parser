require File.expand_path("../../../helpers", __FILE__)

class TestSyntaxAliases < Test::Unit::TestCase
  # 1.8 syntax
  def test_syntax_alias_1_8_6
    syntax = Regexp::Syntax.new 'ruby/1.8.6'

    assert syntax.is_a?(Regexp::Syntax::V1_8_6)
  end

  def test_syntax_alias_1_8_alias
    syntax = Regexp::Syntax.new 'ruby/1.8'

    assert syntax.is_a?(Regexp::Syntax::V1_8_6)
  end

  # 1.9 syntax
  def test_syntax_alias_1_9_1
    syntax = Regexp::Syntax.new 'ruby/1.9.1'

    assert syntax.is_a?(Regexp::Syntax::V1_9_1)
  end

  def test_syntax_alias_1_9_alias
    syntax = Regexp::Syntax.new 'ruby/1.9'

    assert syntax.is_a?(Regexp::Syntax::V1_9_3)
  end

  # 2.0 syntax
  def test_syntax_alias_2_0_0
    syntax = Regexp::Syntax.new 'ruby/2.0.0'

    assert syntax.is_a?(Regexp::Syntax::V1_9)
  end

  def test_syntax_alias_2_0_alias
    syntax = Regexp::Syntax.new 'ruby/2.0'

    assert syntax.is_a?(Regexp::Syntax::V2_0_0)
  end

  # 2.1 syntax
  def test_syntax_alias_2_1_alias
    syntax = Regexp::Syntax.new 'ruby/2.1'

    assert syntax.is_a?(Regexp::Syntax::V2_0_0)
  end

  # 2.2 syntax
  def test_syntax_alias_2_2_0
    syntax = Regexp::Syntax.new 'ruby/2.2.0'

    assert syntax.is_a?(Regexp::Syntax::V2_0_0)
  end

  def test_syntax_alias_2_2_10
    syntax = Regexp::Syntax.new 'ruby/2.2.10'

    assert syntax.is_a?(Regexp::Syntax::V2_0_0)
  end

  def test_syntax_alias_2_2_alias
    syntax = Regexp::Syntax.new 'ruby/2.2'

    assert syntax.is_a?(Regexp::Syntax::V2_0_0)
  end

  # 2.3 syntax
  def test_syntax_alias_2_3_0
    syntax = Regexp::Syntax.new 'ruby/2.3.0'

    assert syntax.is_a?(Regexp::Syntax::V2_3_0)
  end

  def test_syntax_alias_2_3
    syntax = Regexp::Syntax.new 'ruby/2.3'

    assert syntax.is_a?(Regexp::Syntax::V2_3_0)
  end

  # 2.4 syntax
  def test_syntax_alias_2_4_0
    syntax = Regexp::Syntax.new 'ruby/2.4.0'

    assert syntax.is_a?(Regexp::Syntax::V2_4_0)
  end

  def test_syntax_alias_2_4_1
    syntax = Regexp::Syntax.new 'ruby/2.4.1'

    assert syntax.is_a?(Regexp::Syntax::V2_4_1)
  end

  # 2.5 syntax
  def test_syntax_alias_2_5_0
    syntax = Regexp::Syntax.new 'ruby/2.5.0'

    assert syntax.is_a?(Regexp::Syntax::V2_4_1)
    assert syntax.is_a?(Regexp::Syntax::V2_5_0)
  end

  def test_syntax_alias_2_5
    syntax = Regexp::Syntax.new 'ruby/2.5'

    assert syntax.is_a?(Regexp::Syntax::V2_5_0)
  end

  # 2.6 syntax
  def test_syntax_alias_2_6_0
    syntax = Regexp::Syntax.new 'ruby/2.6.0'

    assert syntax.is_a?(Regexp::Syntax::V2_5_0)
    assert syntax.is_a?(Regexp::Syntax::V2_6_0)
  end

  def test_syntax_alias_2_6
    syntax = Regexp::Syntax.new 'ruby/2.6'

    assert syntax.is_a?(Regexp::Syntax::V2_5_0)
  end

  def test_future_alias_warning
    _, stderr_output = capture_output { Regexp::Syntax.new 'ruby/5.0' }

    assert_match(/This library .* but you are running .* \(feature set of .*\)/,
                 stderr_output)
  end
end
