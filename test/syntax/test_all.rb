require File.expand_path("../../helpers", __FILE__)

require File.expand_path("../ruby/test_all", __FILE__)

class TestSyntax < Test::Unit::TestCase

  def test_syntax_unknown_name
    assert_raise( Regexp::Syntax::UnknownSyntaxNameError ) {
      Regexp::Syntax.instantiate('ruby/1.0')
    }
  end

  def test_syntax_missing_spec
    assert_raise( Regexp::Syntax::MissingSyntaxSpecError ) {
      RL.scan('abc', 'ruby/1.6')
    }
  end

  def test_syntax_not_implemented
    assert_raise( Regexp::Syntax::NotImplementedError ) {
      RP.parse('\p{alpha}', 'ruby/1.8')
    }
  end

end
