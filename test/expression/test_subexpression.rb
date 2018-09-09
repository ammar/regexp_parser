require File.expand_path("../../helpers", __FILE__)

class ExpressionSubexpression < Test::Unit::TestCase

  def test_subexpression_ts_te
    regx = /abcd|ghij|klmn|pqur/
    root = RP.parse(regx)

    alt = root.first

    {
      0 => [  0,  4 ],
      1 => [  5,  9 ],
      2 => [ 10, 14 ],
      3 => [ 15, 19 ],
    }.each do |index, span|
      sequence = alt[index]

      assert_equal span[0], sequence.ts
      assert_equal span[1], sequence.te
    end
  end

  def test_subexpression_nesting_level
    root = RP.parse(/a(b(c\d|[ef-g[h]]))/)

    tests = {
      'a'         => 1,
      'b'         => 2,
      '|'         => 3,
      'c\d'       => 4, # first alternative
      'c'         => 5,
      '\d'        => 5,
      '[ef-g[h]]' => 4, # second alternative
      'e'         => 5,
      '-'         => 5,
      'f'         => 6,
      'g'         => 6,
      'h'         => 6,
    }

    root.each_expression do |exp|
      next unless (expected_nesting_level = tests.delete(exp.text))
      assert_equal exp.nesting_level, expected_nesting_level
    end

    assert tests.empty?
  end

  def test_subexpression_dig
    root = RP.parse(/(((a)))/)

    assert_equal '(((a)))', root.dig(0).to_s
    assert_equal 'a',       root.dig(0, 0, 0, 0).to_s
    assert_nil              root.dig(0, 0, 0, 0, 0)
    assert_nil              root.dig(3, 7)
  end
end
