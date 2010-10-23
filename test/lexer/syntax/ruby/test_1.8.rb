require File.expand_path("../../../../helpers", __FILE__)

class TestSyntaxRuby_V18 < Test::Unit::TestCase

  def test_lexer_syntax_ruby_v18
    assert_instance_of( Array, RL.scan('abc', 'ruby/1.8'))
  end

end
