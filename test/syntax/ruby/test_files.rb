require File.expand_path("../../../helpers", __FILE__)

class TestSyntaxFiles < Test::Unit::TestCase

  # 1.8 syntax files
  def test_syntax_file_1_8_6
    syntax = Regexp::Syntax.new 'ruby/1.8.6'

    assert syntax.kind_of?(Regexp::Syntax::Ruby::V186)
  end

  def test_syntax_file_1_8_7
    syntax = Regexp::Syntax.new 'ruby/1.8.7'

    assert syntax.kind_of?(Regexp::Syntax::Ruby::V187)
  end

  def test_syntax_file_1_8_alias
    syntax = Regexp::Syntax.new 'ruby/1.8'

    assert syntax.kind_of?(Regexp::Syntax::Ruby::V187)
  end


  # 1.9 syntax files
  def test_syntax_file_1_9_1
    syntax = Regexp::Syntax.new 'ruby/1.9.1'

    assert syntax.kind_of?(Regexp::Syntax::Ruby::V191)
  end

  def test_syntax_file_1_9_2
    syntax = Regexp::Syntax.new 'ruby/1.9.2'

    assert syntax.kind_of?(Regexp::Syntax::Ruby::V192)
  end

  def test_syntax_file_1_9_3
    syntax = Regexp::Syntax.new 'ruby/1.9.3'

    assert syntax.kind_of?(Regexp::Syntax::Ruby::V193)
  end

  def test_syntax_file_1_9_alias
    syntax = Regexp::Syntax.new 'ruby/1.9'

    assert syntax.kind_of?(Regexp::Syntax::Ruby::V193)
  end


  # 2.0 syntax files
  def test_syntax_file_2_0_0
    syntax = Regexp::Syntax.new 'ruby/2.0.0'

    assert syntax.kind_of?(Regexp::Syntax::Ruby::V19)
  end

  def test_syntax_file_2_0_alias
    syntax = Regexp::Syntax.new 'ruby/2.0'

    assert syntax.kind_of?(Regexp::Syntax::Ruby::V200)
  end


  # 2.1 syntax files
  def test_syntax_file_2_1_0
    syntax = Regexp::Syntax.new 'ruby/2.1.0'

    assert syntax.kind_of?(Regexp::Syntax::Ruby::V20)
  end

  def test_syntax_file_2_1_2
    syntax = Regexp::Syntax.new 'ruby/2.1.2'

    assert syntax.kind_of?(Regexp::Syntax::Ruby::V210)
  end

  def test_syntax_file_2_1_3
    syntax = Regexp::Syntax.new 'ruby/2.1.3'

    assert syntax.kind_of?(Regexp::Syntax::Ruby::V212)
  end

  def test_syntax_file_2_1_4
    syntax = Regexp::Syntax.new 'ruby/2.1.4'

    assert syntax.kind_of?(Regexp::Syntax::Ruby::V213)
  end

  def test_syntax_file_2_1_5
    syntax = Regexp::Syntax.new 'ruby/2.1.5'

    assert syntax.kind_of?(Regexp::Syntax::Ruby::V214)
  end

  def test_syntax_file_2_1_6
    syntax = Regexp::Syntax.new 'ruby/2.1.6'

    assert syntax.kind_of?(Regexp::Syntax::Ruby::V215)
  end

  def test_syntax_file_2_1_alias
    syntax = Regexp::Syntax.new 'ruby/2.1'

    assert syntax.kind_of?(Regexp::Syntax::Ruby::V216)
  end


  # 2.2 syntax files
  def test_syntax_file_2_2_0
    syntax = Regexp::Syntax.new 'ruby/2.2.0'

    assert syntax.kind_of?(Regexp::Syntax::Ruby::V21)
  end

  def test_syntax_file_2_2_1
    syntax = Regexp::Syntax.new 'ruby/2.2.1'

    assert syntax.kind_of?(Regexp::Syntax::Ruby::V220)
  end

  def test_syntax_file_2_2_2
    syntax = Regexp::Syntax.new 'ruby/2.2.2'

    assert syntax.kind_of?(Regexp::Syntax::Ruby::V221)
  end

  def test_syntax_file_2_2_alias
    syntax = Regexp::Syntax.new 'ruby/2.2'

    assert syntax.kind_of?(Regexp::Syntax::Ruby::V222)
  end

end
