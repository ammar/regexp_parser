require File.expand_path("../helpers", __FILE__)

class TestRegexpParserEscapes < Test::Unit::TestCase

  def test_parse_control_sequence_short
    #root = RP.parse(/\b\d\\\c2\C-C\M-\C-2/)
  end

end
