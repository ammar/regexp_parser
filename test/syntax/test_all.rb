require File.expand_path("../../helpers", __FILE__)

%w{posix ruby}.each do|syntax|
  require File.expand_path("../#{syntax}/test_all", __FILE__)
end

class TestSyntax < Test::Unit::TestCase

  def test_lexer_syntax
  end

end
