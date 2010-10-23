require File.expand_path("../../../../helpers", __FILE__)

%w{bre ere}.each do|tc|
  require File.expand_path("../test_#{tc}", __FILE__)
end

class TestSyntaxPosix < Test::Unit::TestCase

  def test_lexer_posix_syntax
  end

end
