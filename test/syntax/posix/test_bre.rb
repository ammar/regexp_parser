require File.expand_path("../../../helpers", __FILE__)

class TestSyntaxPosix_BRE < Test::Unit::TestCase

  def test_lexer_syntax_posix_bre
    assert_instance_of( Array, RL.scan('abc', 'posix/bre'))
  end

end
