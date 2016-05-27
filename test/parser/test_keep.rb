require File.expand_path("../../helpers", __FILE__)

class ParserKeep < Test::Unit::TestCase

  def test_parse_keep
    regexp = /ab\Kcd/
    root   = RP.parse(regexp)

    assert_equal Keep::Mark, root[1].class
    assert_equal '\\K',      root[1].text
  end

  def test_parse_keep_nested
    regexp = /(a\\\Kb)/
    root   = RP.parse(regexp)

    assert_equal Keep::Mark, root[0][2].class
    assert_equal '\\K',      root[0][2].text
  end

end
