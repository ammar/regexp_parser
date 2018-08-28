require File.expand_path("../../helpers", __FILE__)

class ExpressionClone < Test::Unit::TestCase

  def test_expression_clone_base
    root = RP.parse(/^(?i:a)b+$/i)
    copy = root.clone

    refute_equal copy.object_id, root.object_id

    # The text content is equal but the objects are not.
    assert_equal copy.text,           root.text
    refute_equal copy.text.object_id, root.text.object_id

    root_1 = root.expressions[1]
    copy_1 = copy.expressions[1]

    # The options hash contents are equal but the objects are not.
    assert_equal copy_1.options,           root_1.options
    refute_equal copy_1.options.object_id, root_1.options.object_id

    root_2 = root.expressions[2]
    copy_2 = copy.expressions[2]

    assert root_2.quantified?
    assert copy_2.quantified?

    # The quantifier contents are equal but the objects are not.
    assert_equal copy_2.quantifier.text,
                 root_2.quantifier.text

    refute_equal copy_2.quantifier.text.object_id,
                 root_2.quantifier.text.object_id

    refute_equal copy_2.quantifier.object_id,
                 root_2.quantifier.object_id
  end

  def test_expression_clone_subexpression
    root = RP.parse(/^a(b([cde])f)g$/)
    copy = root.clone

    assert root.respond_to?(:expressions)
    assert copy.respond_to?(:expressions)

    # The expressions arrays are not equal.
    refute_equal copy.expressions.object_id,
                 root.expressions.object_id

    # The expressions in the arrays are not equal.
    copy.expressions.each_with_index do |exp, index|
      refute_equal exp.object_id,
                   root.expressions[index].object_id
    end

    # The expressions in nested expressions are not equal.
    copy.expressions[2].each_with_index do |exp, index|
      refute_equal exp.object_id,
                   root.expressions[2][index].object_id
    end
  end

  # ruby 1.8 does not implement named groups
  def test_expression_clone_named_group
    root = RP.parse('^(?<somename>a)+bc$')
    copy = root.clone

    root_1 = root.expressions[1]
    copy_1 = copy.expressions[1]

    # The names are equal but their objects are not.
    assert_equal copy_1.name,           root_1.name
    refute_equal copy_1.name.object_id, root_1.name.object_id

    # Verify super: text objects should be different.
    assert_equal copy_1.text, root_1.text

    # Verify super: expressions arrays are not equal.
    refute_equal copy_1.expressions.object_id,
                 root_1.expressions.object_id

    # Verify super: expressions in the arrays are not equal.
    copy_1.expressions.each_with_index do |exp, index|
      refute_equal exp.object_id,
                   root_1.expressions[index].object_id
    end
  end

end
