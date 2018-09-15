require File.expand_path("../../helpers", __FILE__)

class TestParserRefcalls < Test::Unit::TestCase
  def test_parse_traditional_number_backref
    root = RP.parse('(abc)\1', 'ruby/1.9')
    exp  = root[1]

    assert_instance_of Backreference::Number, exp
    assert_equal 1,    exp.number
  end

  def test_parse_backref_named_ab
    root = RP.parse('(?<X>abc)\k<X>', 'ruby/1.9')
    exp  = root[1]

    assert_instance_of Backreference::Name, exp
    assert_equal 'X',  exp.name
  end

  def test_parse_backref_named_sq
    root = RP.parse("(?<X>abc)\\k'X'", 'ruby/1.9')
    exp  = root[1]

    assert_instance_of Backreference::Name, exp
    assert_equal 'X',  exp.name
  end

  def test_parse_backref_number_ab
    root = RP.parse('(abc)\k<1>', 'ruby/1.9')
    exp  = root[1]

    assert_instance_of Backreference::Number, exp
    assert_equal 1,    exp.number
  end

  def test_parse_backref_number_sq
    root = RP.parse("(abc)\\k'1'", 'ruby/1.9')
    exp  = root[1]

    assert_instance_of Backreference::Number, exp
    assert_equal 1,    exp.number
  end

  def test_parse_backref_number_relative_ab
    root = RP.parse('(abc)\k<-1>', 'ruby/1.9')
    exp  = root[1]

    assert_instance_of Backreference::NumberRelative, exp
    assert_equal(-1,   exp.number)
  end

  def test_parse_backref_number_relative_sq
    root = RP.parse("(abc)\\k'-1'", 'ruby/1.9')
    exp  = root[1]

    assert_instance_of Backreference::NumberRelative, exp
    assert_equal(-1,   exp.number)
  end

  def test_parse_backref_name_call_ab
    root = RP.parse('(?<X>abc)\g<X>', 'ruby/1.9')
    exp  = root[1]

    assert_instance_of Backreference::NameCall, exp
    assert_equal 'X',  exp.name
  end

  def test_parse_backref_name_call_sq
    root = RP.parse("(?<X>abc)\\g'X'", 'ruby/1.9')
    exp  = root[1]

    assert_instance_of Backreference::NameCall, exp
    assert_equal 'X',  exp.name
  end

  def test_parse_backref_number_call_ab
    root = RP.parse('(abc)\g<1>', 'ruby/1.9')
    exp  = root[1]

    assert_instance_of Backreference::NumberCall, exp
    assert_equal 1,    exp.number
  end

  def test_parse_backref_number_call_sq
    root = RP.parse("(abc)\\g'1'", 'ruby/1.9')
    exp  = root[1]

    assert_instance_of Backreference::NumberCall, exp
    assert_equal 1,    exp.number
  end

  def test_parse_backref_number_relative_call_ab
    root = RP.parse('(abc)\g<-1>', 'ruby/1.9')
    exp  = root[1]

    assert_instance_of Backreference::NumberCallRelative, exp
    assert_equal(-1,   exp.number)
  end

  def test_parse_backref_number_relative_call_sq
    root = RP.parse("(abc)\\g'-1'", 'ruby/1.9')
    exp  = root[1]

    assert_instance_of Backreference::NumberCallRelative, exp
    assert_equal(-1,   exp.number)
  end

  def test_parse_backref_number_relative_forward_call_ab
    root = RP.parse('\g<+1>(abc)', 'ruby/1.9')
    exp  = root[0]

    assert_instance_of Backreference::NumberCallRelative, exp
    assert_equal 1,    exp.number
  end

  def test_parse_backref_number_relative_forward_call_sq
    root = RP.parse("\\g'+1'(abc)", 'ruby/1.9')
    exp  = root[0]

    assert_instance_of Backreference::NumberCallRelative, exp
    assert_equal 1,    exp.number
  end

  def test_parse_backref_name_recursion_level_ab
    root = RP.parse('(?<X>abc)\k<X-0>', 'ruby/1.9')
    exp  = root[1]

    assert_instance_of Backreference::NameRecursionLevel, exp
    assert_equal 'X',  exp.name
    assert_equal 0,    exp.recursion_level
  end

  def test_parse_backref_name_recursion_level_sq
    root = RP.parse("(?<X>abc)\\k'X-0'", 'ruby/1.9')
    exp  = root[1]

    assert_instance_of Backreference::NameRecursionLevel, exp
    assert_equal 'X',  exp.name
    assert_equal 0,    exp.recursion_level
  end

  def test_parse_backref_number_recursion_level_ab
    root = RP.parse('(abc)\k<1-0>', 'ruby/1.9')
    exp  = root[1]

    assert_instance_of Backreference::NumberRecursionLevel, exp
    assert_equal 1,    exp.number
    assert_equal 0,    exp.recursion_level
  end

  def test_parse_backref_number_recursion_level_sq
    root = RP.parse("(abc)\\k'1-0'", 'ruby/1.9')
    exp  = root[1]

    assert_instance_of Backreference::NumberRecursionLevel, exp
    assert_equal 1,    exp.number
    assert_equal 0,    exp.recursion_level
  end

  def test_parse_backref_negative_number_recursion_level
    root = RP.parse("(abc)\\k'-1+0'", 'ruby/1.9')
    exp  = root[1]

    assert_instance_of Backreference::NumberRecursionLevel, exp
    assert_equal(-1,   exp.number)
    assert_equal 0,    exp.recursion_level
  end

  def test_parse_backref_number_positive_recursion_level
    root = RP.parse("(abc)\\k'1+1'", 'ruby/1.9')
    exp  = root[1]

    assert_instance_of Backreference::NumberRecursionLevel, exp
    assert_equal 1,    exp.number
    assert_equal 1,    exp.recursion_level
  end

  def test_parse_backref_number_negative_recursion_level
    root = RP.parse("(abc)\\k'1-1'", 'ruby/1.9')
    exp  = root[1]

    assert_instance_of Backreference::NumberRecursionLevel, exp
    assert_equal 1,    exp.number
    assert_equal(-1,   exp.recursion_level)
  end
end
