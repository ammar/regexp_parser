require File.expand_path("../../helpers", __FILE__)

%w{posix ruby}.each do|syntax|
  require File.expand_path("../#{syntax}/test_all", __FILE__)
end

class TestSyntax < Test::Unit::TestCase

  def test_syntax_unknown_name
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
