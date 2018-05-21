require File.expand_path("../../helpers", __FILE__)

class TestParserPosixClasses < Test::Unit::TestCase
  def test_parse_posix_class
    root = RP.parse('[[:word:]]')
    exp  = root[0][0]

    assert_equal PosixClass, exp.class
    assert_equal :posixclass, exp.type
    assert_equal :word, exp.token
    assert_equal 'word', exp.name
    assert_equal '[:word:]', exp.text
    refute       exp.negative?
  end

  def test_parse_negative_posix_class
    root = RP.parse('[[:^word:]]')
    exp  = root[0][0]

    assert_equal PosixClass, exp.class
    assert_equal :nonposixclass, exp.type
    assert_equal :word, exp.token
    assert_equal 'word', exp.name
    assert_equal '[:^word:]', exp.text
    assert       exp.negative?
  end
end
