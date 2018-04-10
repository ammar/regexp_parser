require File.expand_path("../../helpers", __FILE__)

class TestSyntax < Test::Unit::TestCase

  def test_syntax_unknown_name
    assert_raise( Regexp::Syntax::UnknownSyntaxNameError ) {
      Regexp::Syntax.new('ruby/1.0')
    }
  end

  def test_syntax_new
    assert_instance_of Regexp::Syntax::V1_9_3,
                       Regexp::Syntax.new('ruby/1.9.3')
  end

  def test_syntax_not_implemented
    assert_raise( Regexp::Syntax::NotImplementedError ) {
      RP.parse('\p{alpha}', 'ruby/1.8')
    }
  end

  def test_syntax_supported?
    assert_equal false, Regexp::Syntax.supported?('ruby/1.1.1')
    assert_equal true, Regexp::Syntax.supported?('ruby/2.4.3')
    assert_equal true, Regexp::Syntax.supported?('ruby/2.5')
  end

  def test_syntax_invalid_version
    assert_raise( Regexp::Syntax::InvalidVersionNameError ) {
      Regexp::Syntax.version_class('2.0.0')
    }

    assert_raise( Regexp::Syntax::InvalidVersionNameError ) {
      Regexp::Syntax.version_class('ruby/20')
    }
  end

  def test_syntax_version_class_tiny_version
    assert_equal Regexp::Syntax::V1_9_3,
                 Regexp::Syntax.version_class('ruby/1.9.3')

    assert_equal Regexp::Syntax::V2_3_1,
                 Regexp::Syntax.version_class('ruby/2.3.1')
  end

  def test_syntax_version_class_minor_version
    assert_equal Regexp::Syntax::V1_9,
                 Regexp::Syntax.version_class('ruby/1.9')

    assert_equal Regexp::Syntax::V2_3,
                 Regexp::Syntax.version_class('ruby/2.3')
  end

end
