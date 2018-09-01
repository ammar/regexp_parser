require File.expand_path("../../helpers", __FILE__)

class SubexpressionTraverse < Test::Unit::TestCase

  def test_subexpression_traverse
    root = RP.parse(/a(b(c(d)))|g[h-i]j|klmn/)

    enters = 0
    visits = 0
    exits  = 0

    root.traverse {|event, exp, index|
      enters += 1 if event == :enter
      visits += 1 if event == :visit
      exits  += 1 if event == :exit
    }

    assert_equal 9,     enters
    assert_equal exits, enters

    assert_equal 9, visits
  end

  def test_subexpression_traverse_include_self
    root = RP.parse(/a(b(c(d)))|g[h-i]j|klmn/)

    enters = 0
    visits = 0
    exits  = 0

    root.traverse(true) {|event, exp, index|
      enters += 1 if event == :enter
      visits += 1 if event == :visit
      exits  += 1 if event == :exit
    }

    assert_equal 10,    enters
    assert_equal exits, enters

    assert_equal 9, visits
  end

  def test_subexpression_walk_alias
    root = RP.parse(/abc/)

    assert_equal true, root.respond_to?(:walk)
  end

  def test_subexpression_each_expression
    root = RP.parse(/a(?x:b(c))|g[h-k]/)

    count = 0
    root.each_expression {|exp, index|
      count += 1
    }

    assert_equal 13, count
  end

  def test_subexpression_each_expression_include_self
    root = RP.parse(/a(?x:b(c))|g[h-k]/)

    count = 0
    root.each_expression(true) {|exp, index|
      count += 1
    }

    assert_equal 14, count
  end

  def test_subexpression_each_expression_indices
    root = RP.parse(/a(b)c/)

    indices = []
    root.each_expression {|exp, index| indices << index}

    assert_equal [0, 1, 0, 2], indices
  end

  def test_subexpression_each_expression_indices_include_self
    root = RP.parse(/a(b)c/)

    indices = []
    root.each_expression(true) {|exp, index| indices << index}

    assert_equal [0, 0, 1, 0, 2], indices
  end

  def test_subexpression_flat_map_without_block
    root = RP.parse(/a(b([c-e]+))?/)

    array = root.flat_map

    assert_equal Array, array.class
    assert_equal 8, array.length

    array.each do |item|
      assert_equal Array, item.class
      assert_equal 2,     item.length
      assert_equal true,  item.first.is_a?(Regexp::Expression::Base)
      assert_equal true,  item.last.is_a?(Integer)
    end
  end

  def test_subexpression_flat_map_without_block_include_self
    root = RP.parse(/a(b([c-e]+))?/)

    array = root.flat_map(true)

    assert_equal Array, array.class
    assert_equal 9, array.length
  end

  def test_subexpression_flat_map_indices
    root = RP.parse(/a(b([c-e]+))?f*g/)

    indices = root.flat_map {|exp, index| index}

    assert_equal [0, 1, 0, 1, 0, 0, 0, 1, 2, 3], indices
  end

  def test_subexpression_flat_map_indices_include_self
    root = RP.parse(/a(b([c-e]+))?f*g/)

    indices = root.flat_map(true) {|exp, index| index}

    assert_equal [0, 0, 1, 0, 1, 0, 0, 0, 1, 2, 3], indices
  end

  def test_subexpression_flat_map_expressions
    root = RP.parse(/a(b(c(d)))/)

    levels = root.flat_map {|exp, index|
      [exp.level, exp.text] if exp.terminal?
    }.compact

    assert_equal [
        [0, 'a'], [1, 'b'], [2, 'c'], [3, 'd']
      ], levels
  end

  def test_subexpression_flat_map_expressions_include_self
    root = RP.parse(/a(b(c(d)))/)

    levels = root.flat_map(true) {|exp, index|
      [exp.level, exp.to_s]
    }.compact

    assert_equal [
        [nil, 'a(b(c(d)))'],
        [0,   'a'],
        [0,   '(b(c(d)))'],
        [1,   'b'],
        [1,   '(c(d))'],
        [2,   'c'],
        [2,   '(d)'],
        [3,   'd']
      ], levels
  end

end
