require File.expand_path("../../helpers", __FILE__)

class ExpressionToH < Test::Unit::TestCase

  def test_expression_to_h
    h = RP.parse('abc').to_h

    assert_equal( h, {
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
    })
  end

  def test_expression_quantifier_to_h
    h = RP.parse('a{2,4}')[0].quantifier.to_h

    assert_equal( h, {
      :max   => 4,
      :min   => 2,
      :mode  => :greedy,
      :text  => '{2,4}',
      :token => :interval
    })
  end

end
