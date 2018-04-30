require File.expand_path("../../helpers", __FILE__)

class ExpressionSet < Test::Unit::TestCase

  def test_expression_set_expand_members_digit
    set = RP.parse('[\d]').first

    assert_equal ['0-9'],       set.expand_members
    assert_equal ['\p{Digit}'], set.expand_members(true)
  end

  def test_expression_set_expand_members_nondigit
    set = RP.parse('[\D]').first

    assert_equal ['^0-9'],      set.expand_members
    assert_equal ['\P{Digit}'], set.expand_members(true)
  end

  def test_expression_set_expand_members_word
    set = RP.parse('[\w]').first

    assert_equal ['A-Za-z0-9_'], set.expand_members
    assert_equal ['\p{Word}'],   set.expand_members(true)
  end

  def test_expression_set_expand_members_nonword
    set = RP.parse('[\W]').first

    assert_equal ['^A-Za-z0-9_'], set.expand_members
    assert_equal ['\P{Word}'],    set.expand_members(true)
  end

  def test_expression_set_expand_members_space
    set = RP.parse('[\s]').first

    assert_equal [' \t\f\v\n\r'], set.expand_members
    assert_equal ['\p{Space}'],   set.expand_members(true)
  end

  def test_expression_set_expand_members_nonspace
    set = RP.parse('[\S]').first

    assert_equal ['^ \t\f\v\n\r'], set.expand_members
    assert_equal ['\P{Space}'],    set.expand_members(true)
  end

  def test_expression_set_expand_members_xdigit
    set = RP.parse('[\h]').first

    assert_equal ['0-9A-Fa-f'],  set.expand_members
    assert_equal ['\p{Xdigit}'], set.expand_members(true)
  end

  def test_expression_set_expand_members_nonxdigit
    set = RP.parse('[\H]').first

    assert_equal ['^0-9A-Fa-f'], set.expand_members
    assert_equal ['\P{Xdigit}'], set.expand_members(true)
  end

  def test_expression_set_include
    set = RP.parse('[ac-eh\s[:digit:]\x20[b]]').first

    assert set.include?('a')
    assert set.include?('a', true)
    assert set.include?('c-e')
    assert set.include?('h')
    assert set.include?('\s')
    assert set.include?('[:digit:]')
    assert set.include?('\x20')

    assert set.include?('b')
    refute set.include?('b', true) # should not include b directly

    refute set.include?(']')
    refute set.include?('[')
    refute set.include?('x')
    refute set.include?('\S')

    subset = set.last
    assert subset.include?('b')
    refute subset.include?('a')
  end
end
