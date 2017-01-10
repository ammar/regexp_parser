require File.expand_path("../../helpers", __FILE__)

class ExpressionConditionals < Test::Unit::TestCase

  def setup
    @root = RP.parse(/^(a(b))(b(?(1)c|(?(2)d|(?(3)e|f)))g)$/)

    @cond_1 = @root[2][1]
    @cond_2 = @root[2][1][2][0]
    @cond_3 = @root[2][1][2][0][2][0]
  end

  def is_conditional_condition?(exp)
    exp.is_a?(Conditional::Condition)
  end

  def is_conditional_branch?(exp)
    exp.is_a?(Conditional::Branch)
  end

  def test_expression_conditional_root_level
    %w{^ (a(b)) (b(?(1)c|(?(2)d|(?(3)e|f)))g) $}.each_with_index do |t, i|
      assert_equal 0, @root[i].conditional_level
      assert_equal t, @root[i].to_s
    end

    # First capture group
    assert_equal 'b', @root[2][0].text
    assert_equal 0,   @root[2][0].conditional_level
  end

  def test_expression_conditional_level_one
    condition = @cond_1.condition
    branch_1  = @cond_1.branches.first

    # Condition
    assert_equal true,  is_conditional_condition?(condition)
    assert_equal '(1)', condition.text
    assert_equal 1,     condition.conditional_level

    # Branch 1
    assert_equal true,  is_conditional_branch?(branch_1)
    assert_equal 'c',   branch_1.text
    assert_equal 1,     branch_1.conditional_level

    # Literal
    assert_equal 'c',   branch_1.first.text
    assert_equal 1,     branch_1.first.conditional_level

  end

  def test_expression_conditional_level_two
    condition = @cond_2.condition
    branch_1  = @cond_2.branches.first
    branch_2  = @cond_2.branches.last

    assert_equal '(?',   @cond_2.text
    assert_equal 1,      @cond_2.conditional_level

    # Condition
    assert_equal true,   is_conditional_condition?(condition)
    assert_equal '(2)',  condition.text
    assert_equal 2,      condition.conditional_level

    # Branch 1
    assert_equal true,   is_conditional_branch?(branch_1)
    assert_equal 'd',    branch_1.text
    assert_equal 2,      branch_1.conditional_level

    # Literal
    assert_equal 'd',    branch_1.first.text
    assert_equal 2,      branch_1.first.conditional_level

    # Branch 2
    assert_equal '(?',   branch_2.first.text
    assert_equal 2,      branch_2.first.conditional_level
  end

  def test_expression_conditional_level_three
    condition = @cond_3.condition
    branch_1  = @cond_3.branches.first
    branch_2  = @cond_3.branches.last

    # Condition
    assert_equal true,   is_conditional_condition?(condition)
    assert_equal '(3)',  condition.text
    assert_equal 3,      condition.conditional_level

    # Same as branch 2 in level two
    assert_equal '(?',         @cond_3.text
    assert_equal '(?(3)e|f)',  @cond_3.to_s
    assert_equal 2,            @cond_3.conditional_level

    # Branch 1
    assert_equal true,   is_conditional_branch?(branch_1)
    assert_equal 'e',    branch_1.text
    assert_equal 3,      branch_1.conditional_level

    # Literal
    assert_equal 'e',    branch_1.first.text
    assert_equal 3,      branch_1.first.conditional_level

    # Branch 2
    assert_equal true,   is_conditional_branch?(branch_2)
    assert_equal 'f',    branch_2.text
    assert_equal 3,      branch_2.conditional_level

    # Literal
    assert_equal 'f',    branch_2.first.text
    assert_equal 3,      branch_2.first.conditional_level
  end

end
