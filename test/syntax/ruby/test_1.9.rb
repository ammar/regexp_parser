require File.expand_path("../../../helpers", __FILE__)

class TestSyntaxRuby_V19 < Test::Unit::TestCase

  def test_lexer_syntax_ruby_v19
    assert_instance_of( Array, RL.scan('abc', 'ruby/1.9'))
  end

end
