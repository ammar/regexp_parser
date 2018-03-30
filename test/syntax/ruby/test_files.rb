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

    assert syntax.kind_of?(Regexp::Syntax::Ruby::V186)
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

  def test_syntax_file_2_1_alias
    syntax = Regexp::Syntax.new 'ruby/2.1'

    assert syntax.kind_of?(Regexp::Syntax::Ruby::V200)
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

  def test_syntax_file_2_2_alias
    syntax = Regexp::Syntax.new 'ruby/2.2'

    assert syntax.kind_of?(Regexp::Syntax::Ruby::V220)
  end

  # 2.3 syntax files
  def test_syntax_file_2_3_0
    syntax = Regexp::Syntax.new 'ruby/2.3.0'

    assert syntax.kind_of?(Regexp::Syntax::Ruby::V22)
    assert syntax.kind_of?(Regexp::Syntax::Ruby::V230)
  end

  def test_syntax_file_2_3_1
    syntax = Regexp::Syntax.new 'ruby/2.3.1'

    assert syntax.kind_of?(Regexp::Syntax::Ruby::V230)
    assert syntax.kind_of?(Regexp::Syntax::Ruby::V231)
  end

  def test_syntax_file_2_3_alias
    syntax = Regexp::Syntax.new 'ruby/2.3'

    assert syntax.kind_of?(Regexp::Syntax::Ruby::V230)
  end

  # 2.4 syntax files
  def test_syntax_file_2_4_0
    syntax = Regexp::Syntax.new 'ruby/2.4.0'

    assert syntax.kind_of?(Regexp::Syntax::Ruby::V23)
    assert syntax.kind_of?(Regexp::Syntax::Ruby::V240)
  end

  def test_syntax_file_2_4_1
    syntax = Regexp::Syntax.new 'ruby/2.4.1'

    assert syntax.kind_of?(Regexp::Syntax::Ruby::V240)
    assert syntax.kind_of?(Regexp::Syntax::Ruby::V241)
  end

  def test_syntax_file_2_4_2
    syntax = Regexp::Syntax.new 'ruby/2.4.2'

    assert syntax.kind_of?(Regexp::Syntax::Ruby::V241)
    assert syntax.kind_of?(Regexp::Syntax::Ruby::V242)
  end

  # 2.5 syntax files
  def test_syntax_file_2_5_0
    syntax = Regexp::Syntax.new 'ruby/2.5.0'

    assert syntax.kind_of?(Regexp::Syntax::Ruby::V24)
    assert syntax.kind_of?(Regexp::Syntax::Ruby::V250)
  end

  def test_syntax_file_2_5_1
    syntax = Regexp::Syntax.new 'ruby/2.5.1'

    assert syntax.kind_of?(Regexp::Syntax::Ruby::V250)
    assert syntax.kind_of?(Regexp::Syntax::Ruby::V251)
  end

  def test_syntax_file_2_5_alias
    syntax = Regexp::Syntax.new 'ruby/2.5'

    assert syntax.kind_of?(Regexp::Syntax::Ruby::V251)
  end

  # 2.6 syntax files
  def test_syntax_file_2_6_0
    syntax = Regexp::Syntax.new 'ruby/2.6.0'

    assert syntax.kind_of?(Regexp::Syntax::Ruby::V25)
    assert syntax.kind_of?(Regexp::Syntax::Ruby::V260)
  end

  def test_syntax_file_2_6_alias
    syntax = Regexp::Syntax.new 'ruby/2.6'

    assert syntax.kind_of?(Regexp::Syntax::Ruby::V260)
  end
end
