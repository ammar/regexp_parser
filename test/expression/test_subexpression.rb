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

end
