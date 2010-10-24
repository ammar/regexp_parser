require File.expand_path("../../../helpers", __FILE__)

%w{1.8 1.9}.each do|tc|
  require File.expand_path("../test_#{tc}", __FILE__)
end

class TestSyntaxRuby < Test::Unit::TestCase

  def test_lexer_ruby_syntax
  end

end
