require File.expand_path("../../helpers", __FILE__)

class Token < Test::Unit::TestCase

  def test_token_offset
    regexp = /ab?cd/
    tokens = RL.lex(regexp)

    assert_equal 'b',    tokens[1].text
    assert_equal [1, 2], tokens[1].offset

    assert_equal '?',    tokens[2].text
    assert_equal [2, 3], tokens[2].offset

    assert_equal 'cd',   tokens[3].text
    assert_equal [3, 5], tokens[3].offset
  end

  def test_token_length
    regexp = /abc?def/
    tokens = RL.lex(regexp)

    assert_equal 'ab',  tokens[0].text
    assert_equal 2,     tokens[0].length

    assert_equal 'c',   tokens[1].text
    assert_equal 1,     tokens[1].length

    assert_equal '?',   tokens[2].text
    assert_equal 1,     tokens[2].length

    assert_equal 'def', tokens[3].text
    assert_equal 3,     tokens[3].length
  end

  def test_token_to_h
    regexp = /abc?def/
    tokens = RL.lex(regexp)

    assert_equal 'ab', tokens[0].text
    assert_equal({
        :type               => :literal,
        :token              => :literal,
        :text               => 'ab',
        :ts                 => 0,
        :te                 => 2,
        :level              => 0,
        :set_level          => 0,
        :conditional_level  => 0
      }, tokens[0].to_h
    )

    assert_equal '?', tokens[2].text
    assert_equal({
        :type               => :quantifier,
        :token              => :zero_or_one,
        :text               => '?',
        :ts                 => 3,
        :te                 => 4,
        :level              => 0,
        :set_level          => 0,
        :conditional_level  => 0
      }, tokens[2].to_h
    )
  end

  def test_token_next
    regexp = /a+b?c*d{2,3}/
    tokens = RL.lex(regexp)

    a = tokens.first
    assert_equal 'a',  a.text

    plus = a.next
    assert_equal '+',  plus.text

    b = plus.next
    assert_equal 'b',  b.text

    interval = tokens.last
    assert_equal '{2,3}',  interval.text

    assert_equal nil,  interval.next
  end

  def test_token_previous
    regexp = /a+b?c*d{2,3}/
    tokens = RL.lex(regexp)

    interval = tokens.last
    assert_equal '{2,3}',  interval.text

    d = interval.previous
    assert_equal 'd',  d.text

    star = d.previous
    assert_equal '*',  star.text

    c = star.previous
    assert_equal 'c',  c.text

    a = tokens.first
    assert_equal 'a',  a.text
    assert_equal nil,  a.previous
  end

end
