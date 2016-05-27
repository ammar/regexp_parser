require File.expand_path("../../helpers", __FILE__)

class ExpressionToH < Test::Unit::TestCase

  def test_expression_to_h
    root = RP.parse('abc')

    hash = root.to_h

    assert_equal hash, {
      :token             => :root,
      :type              => :expression,
      :text              => 'abc',
      :starts_at         => 0,
      :length            => 3,
      :quantifier        => nil,
      :options           => nil,
      :level             => nil,
      :set_level         => nil,
      :conditional_level => nil,
      :expressions       => [
        {
          :token             => :literal,
          :type              => :literal,
          :text              => 'abc',
          :starts_at         => 0,
          :length            => 3,
          :quantifier        => nil,
          :options           => nil,
          :level             => 0,
          :set_level         => 0,
          :conditional_level => 0
        }
      ]
    }
  end

  def test_expression_quantifier_to_h
    root = RP.parse('a{2,4}')
    exp  = root.expressions.at(0)

    hash = exp.quantifier.to_h

    assert_equal hash, {
      :max   => 4,
      :min   => 2,
      :mode  => :greedy,
      :text  => '{2,4}',
      :token => :interval
    }
  end

end
