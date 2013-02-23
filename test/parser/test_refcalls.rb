require File.expand_path("../../helpers", __FILE__)

class TestParserRefcalls < Test::Unit::TestCase

  def test_parse_backref_named_ab
    t = RP.parse('(?<X>abc)\k<X>', 'ruby/1.9')[1]

    assert_equal( true,  t.is_a?(Backreference::Name) )
  end

  def test_parse_backref_named_sq
    t = RP.parse("(?<X>abc)\\k'X'", 'ruby/1.9')[1]

    assert_equal( true,  t.is_a?(Backreference::Name) )
  end

  def test_parse_backref_number_ab
    t = RP.parse('(abc)\k<1>', 'ruby/1.9')[1]

    assert_equal( true,  t.is_a?(Backreference::Number) )
  end

  def test_parse_backref_number_sq
    t = RP.parse("(abc)\\k'1'", 'ruby/1.9')[1]

    assert_equal( true,  t.is_a?(Backreference::Number) )
  end

  def test_parse_backref_number_relative_ab
    t = RP.parse('(abc)\k<-1>', 'ruby/1.9')[1]

    assert_equal( true,  t.is_a?(Backreference::NumberRelative) )
  end

  def test_parse_backref_number_relative_sq
    t = RP.parse("(abc)\\k'-1'", 'ruby/1.9')[1]

    assert_equal( true,  t.is_a?(Backreference::NumberRelative) )
  end

  def test_parse_backref_name_call_ab
    t = RP.parse('(?<X>abc)\g<X>', 'ruby/1.9')[1]

    assert_equal( true,  t.is_a?(Backreference::NameCall) )
  end

  def test_parse_backref_name_call_sq
    t = RP.parse("(?<X>abc)\\g'X'", 'ruby/1.9')[1]

    assert_equal( true,  t.is_a?(Backreference::NameCall) )
  end

  def test_parse_backref_number_call_ab
    t = RP.parse('(abc)\g<1>', 'ruby/1.9')[1]

    assert_equal( true,  t.is_a?(Backreference::NumberCall) )
  end

  def test_parse_backref_number_call_sq
    t = RP.parse("(abc)\\g'1'", 'ruby/1.9')[1]

    assert_equal( true,  t.is_a?(Backreference::NumberCall) )
  end

  def test_parse_backref_number_relative_call_ab
    t = RP.parse('(abc)\g<-1>', 'ruby/1.9')[1]

    assert_equal( true,  t.is_a?(Backreference::NumberCallRelative) )
  end

  def test_parse_backref_number_relative_call_sq
    t = RP.parse("(abc)\\g'-1'", 'ruby/1.9')[1]

    assert_equal( true,  t.is_a?(Backreference::NumberCallRelative) )
  end

  def test_parse_backref_name_nest_level_ab
    t = RP.parse('(?<X>abc)\k<X-0>', 'ruby/1.9')[1]

    assert_equal( true,  t.is_a?(Backreference::NameNestLevel) )
  end

  def test_parse_backref_name_nest_level_sq
    t = RP.parse("(?<X>abc)\\k'X-0'", 'ruby/1.9')[1]

    assert_equal( true,  t.is_a?(Backreference::NameNestLevel) )
  end

  def test_parse_backref_number_nest_level_ab
    t = RP.parse('(abc)\k<1-0>', 'ruby/1.9')[1]

    assert_equal( true,  t.is_a?(Backreference::NumberNestLevel) )
  end

  def test_parse_backref_number_nest_level_sq
    t = RP.parse("(abc)\\k'1-0'", 'ruby/1.9')[1]

    assert_equal( true,  t.is_a?(Backreference::NumberNestLevel) )
  end

end
