require File.expand_path("../../helpers", __FILE__)

class ExpressionSet < Test::Unit::TestCase

  def test_expression_set_exapnd_members_digit
    set = RP.parse('[\d]').first

    assert_equal ['0-9'],       set.expand_members
    assert_equal ['\p{Digit}'], set.expand_members(true)
  end

  def test_expression_set_exapnd_members_nondigit
    set = RP.parse('[\D]').first

    assert_equal ['^0-9'],      set.expand_members
    assert_equal ['\P{Digit}'], set.expand_members(true)
  end

  def test_expression_set_exapnd_members_word
    set = RP.parse('[\w]').first

    assert_equal ['A-Za-z0-9_'], set.expand_members
    assert_equal ['\p{Word}'],   set.expand_members(true)
  end

  def test_expression_set_exapnd_members_nonword
    set = RP.parse('[\W]').first

    assert_equal ['^A-Za-z0-9_'], set.expand_members
    assert_equal ['\P{Word}'],    set.expand_members(true)
  end

  def test_expression_set_exapnd_members_space
    set = RP.parse('[\s]').first

    assert_equal [' \t\f\v\n\r'], set.expand_members
    assert_equal ['\p{Space}'],   set.expand_members(true)
  end

  def test_expression_set_exapnd_members_nonspace
    set = RP.parse('[\S]').first

    assert_equal ['^ \t\f\v\n\r'], set.expand_members
    assert_equal ['\P{Space}'],    set.expand_members(true)
  end

  def test_expression_set_exapnd_members_xdigit
    set = RP.parse('[\h]').first

    assert_equal ['0-9A-Fa-f'],  set.expand_members
    assert_equal ['\p{Xdigit}'], set.expand_members(true)
  end

  def test_expression_set_exapnd_members_nonxdigit
    set = RP.parse('[\H]').first

    assert_equal ['^0-9A-Fa-f'], set.expand_members
    assert_equal ['\P{Xdigit}'], set.expand_members(true)
  end

end
