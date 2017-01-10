require File.expand_path("../../helpers", __FILE__)

class TestParserConditionals < Test::Unit::TestCase

  def test_parse_conditional
    regexp = /(?<A>a)(?(<A>)T|F)/

    root = RP.parse(regexp, 'ruby/2.0')
    exp  = root.expressions[1]

    assert exp.is_a?(Conditional::Expression),
           "Expected Condition, but got #{exp.class.name}"

    assert_equal exp.type,   :conditional
    assert_equal exp.token,  :open
    assert_equal exp.text,   '(?'
  end


  def test_parse_conditional_condition
    regexp = /(?<A>a)(?(<A>)T|F)/

    root = RP.parse(regexp, 'ruby/2.0')
    exp  = root[1].condition

    assert exp.is_a?(Conditional::Condition),
           "Expected Condition, but got #{exp.class.name}"

    assert_equal exp.type,   :conditional
    assert_equal exp.token,  :condition
    assert_equal exp.text,   '(<A>)'
  end


  def test_parse_conditional_nested_groups
    regexp = /((a)|(b)|((?(2)(c(d|e)+)?|(?(3)f|(?(4)(g|(h)(i)))))))/

    root = RP.parse(regexp, 'ruby/2.0')

    assert_equal regexp.source, root.to_s

    group = root.first
    assert_equal Group::Capture, group.class

    alt = group.first
    assert_equal Alternation, alt.class
    assert_equal 3, alt.length

    all_captures = alt.all? do |exp|
      exp.first.is_a?(Group::Capture)
    end

    assert_equal true, all_captures

    subgroup    = alt[2].first
    conditional = subgroup.first

    assert_equal Conditional::Expression, conditional.class
    assert_equal 3, conditional.length

    assert_equal Conditional::Condition,  conditional[0].class
    assert_equal '(2)',                   conditional[0].text

    condition = conditional.condition
    assert_equal Conditional::Condition,  condition.class
    assert_equal '(2)',                   condition.text

    branches = conditional.branches
    assert_equal 2,      branches.length
    assert_equal Array,  branches.class
  end

  def test_parse_conditional_nested
    regexp = /(a(b(c(d)(e))))(?(1)(?(2)d|(?(3)e|f))|(?(4)(?(5)g|h)))/

    root = RP.parse(regexp, 'ruby/2.0')

    assert_equal regexp.source, root.to_s

    { 1 => [2, root[1]],
      2 => [2, root[1][1][0]],
      3 => [2, root[1][1][0][2][0]],
      4 => [1, root[1][2][0]],
      5 => [2, root[1][2][0][1][0]],
    }.each do |index, test|
      branch_count, exp = test

      assert_equal Conditional::Expression, exp.class
      assert_equal "(#{index})", exp.condition.text
      assert_equal branch_count, exp.branches.length
    end
  end


  def test_parse_conditional_nested_alternation
    regexp = /(a)(?(1)(b|c|d)|(e|f|g))(h)(?(2)(i|j|k)|(l|m|n))|o|p/

    root = RP.parse(regexp, 'ruby/2.0')

    assert_equal regexp.source, root.to_s

    assert_equal Alternation, root.first.class

    [ [3, 'b|c|d', root[0][0][1][1][0][0]],
      [3, 'e|f|g', root[0][0][1][2][0][0]],
      [3, 'i|j|k', root[0][0][3][1][0][0]],
      [3, 'l|m|n', root[0][0][3][2][0][0]],
    ].each do |test|
      alt_count, alt_text, exp = test

      assert_equal Alternation, exp.class
      assert_equal alt_text,    exp.to_s
      assert_equal alt_count,   exp.alternatives.length
    end
  end


  def test_parse_conditional_extra_separator
    regexp = /(?<A>a)(?(<A>)T|)/

    root = RP.parse(regexp, 'ruby/2.0')
    branches = root[1].branches

    assert_equal 2, branches.length

    seq_1, seq_2 = branches

    [seq_1, seq_2].each do |seq|
      assert seq.is_a?( Sequence ),
             "Expected Condition, but got #{seq.class.name}"

      assert_equal :expression, seq.type
      assert_equal :sequence,   seq.token
    end

    assert_equal 'T', seq_1.to_s
    assert_equal '',  seq_2.to_s
  end


  # For source (text) expressions only, ruby raises an error otherwise.
  def test_parse_conditional_excessive_branches
    regexp = '(?<A>a)(?(<A>)T|F|X)'

    assert_raise( Conditional::TooManyBranches ) {
      RP.parse(regexp, 'ruby/2.0')
    }
  end

end
