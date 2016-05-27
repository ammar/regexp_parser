require File.expand_path("../../helpers", __FILE__)

class ExpressionTests < Test::Unit::TestCase

  def test_expression_type?
    root = RP.parse(/abcd|(ghij)|[klmn]/)

    alt = root.first

    assert_equal true,  alt.type?(:meta)
    assert_equal false, alt.type?(:escape)
    assert_equal true,  alt.type?([:meta, :escape])
    assert_equal false, alt.type?([:literal, :escape])
    assert_equal true,  alt.type?(:*)
    assert_equal true,  alt.type?([:*])
    assert_equal true,  alt.type?([:literal, :escape, :*])

    seq_1 = alt[0]
    assert_equal true,  seq_1.type?(:expression)
    assert_equal true,  seq_1.first.type?(:literal)

    seq_2 = alt[1]
    assert_equal true,  seq_2.type?(:*)
    assert_equal true,  seq_2.first.type?(:group)

    seq_3 = alt[2]
    assert_equal true,  seq_3.first.type?(:set)
  end

  def test_expression_is?
    root = RP.parse(/.+|\.?/)

    assert_equal true,  root.is?(:*)

    alt = root.first
    assert_equal true,  alt.is?(:*)
    assert_equal true,  alt.is?(:alternation)
    assert_equal true,  alt.is?(:alternation, :meta)

    seq_1 = alt[0]
    assert_equal true,  seq_1.is?(:sequence)
    assert_equal true,  seq_1.is?(:sequence, :expression)

    assert_equal true,  seq_1.first.is?(:dot)
    assert_equal false, seq_1.first.is?(:dot, :escape)
    assert_equal true,  seq_1.first.is?(:dot, :meta)
    assert_equal true,  seq_1.first.is?(:dot, [:escape, :meta])

    seq_2 = alt[1]
    assert_equal true,  seq_2.first.is?(:dot)
    assert_equal true,  seq_2.first.is?(:dot, :escape)
    assert_equal false, seq_2.first.is?(:dot, :meta)
    assert_equal true,  seq_2.first.is?(:dot, [:meta, :escape])
  end

  def test_expression_one_of?
    root = RP.parse(/\Aab(c[\w])d|e.\z/)

    assert_equal true,  root.one_of?(:*)
    assert_equal true,  root.one_of?(:* => :*)
    assert_equal true,  root.one_of?(:* => [:*])

    alt = root.first
    assert_equal true,  alt.one_of?(:*)
    assert_equal true,  alt.one_of?(:meta)
    assert_equal true,  alt.one_of?(:meta, :alternation)
    assert_equal false, alt.one_of?(:meta => [:dot, :bogus])
    assert_equal true,  alt.one_of?(:meta => [:dot, :alternation])

    seq_1 = alt[0]
    assert_equal true,  seq_1.one_of?(:expression)
    assert_equal true,  seq_1.one_of?(:expression => :sequence)

    assert_equal true,  seq_1.first.one_of?(:anchor)
    assert_equal true,  seq_1.first.one_of?(:anchor => :bos)
    assert_equal false, seq_1.first.one_of?(:anchor => :eos)
    assert_equal true,  seq_1.first.one_of?(:anchor => [:escape, :meta, :bos])
    assert_equal false, seq_1.first.one_of?(:anchor => [:escape, :meta, :eos])

    seq_2 = alt[1]
    assert_equal true,  seq_2.first.one_of?(:literal)

    assert_equal true,  seq_2[1].one_of?(:meta)
    assert_equal true,  seq_2[1].one_of?(:meta => :dot)
    assert_equal false, seq_2[1].one_of?(:meta => :alternation)
    assert_equal true,  seq_2[1].one_of?(:meta => [:dot])

    assert_equal false, seq_2.last.one_of?(:group)
    assert_equal false, seq_2.last.one_of?(:group => [:*])
    assert_equal false, seq_2.last.one_of?(:group => [:*], :meta => :*)

    assert_equal true,  seq_2.last.one_of?(:meta => [:*], :* => :*)
    assert_equal true,  seq_2.last.one_of?(:meta => [:*], :anchor => :*)
    assert_equal true,  seq_2.last.one_of?(:meta => [:*], :anchor => :eos)
    assert_equal false, seq_2.last.one_of?(:meta => [:*], :anchor => [:bos])
    assert_equal true,  seq_2.last.one_of?(:meta => [:*], :anchor => [:bos, :eos])
  end

end
