require File.expand_path("../../helpers", __FILE__)

class TestParserGroups < Test::Unit::TestCase

  def test_parse_root_options_mi
    t = RP.parse(/[abc]/mi, 'ruby/1.8')

    assert_equal true,  t.m?
    assert_equal true,  t.i?
    assert_equal false, t.x?
  end

  def test_parse_option_group
    t = RP.parse(/(?m:a)/, 'ruby/1.8')

    assert_equal Group::Options, t.expressions[0].class
    assert_equal :options,       t.expressions[0].token

    assert_equal true,  t.expressions[0].m?
    assert_equal false, t.expressions[0].i?
    assert_equal false, t.expressions[0].x?

    assert_equal true,  t.expressions[0].option_changes[:m]
    assert_equal nil,   t.expressions[0].option_changes[:i]
  end

  def test_parse_self_defeating_option_group
    t = RP.parse(/(?m-m:a)/, 'ruby/1.8')

    assert_equal false, t.expressions[0].m?
    assert_equal false, t.expressions[0].i?
    assert_equal false, t.expressions[0].x?

    assert_equal false, t.expressions[0].option_changes[:m]
    assert_equal nil,   t.expressions[0].option_changes[:i]
  end

  def test_parse_nested_options_activate_one
    t = RP.parse(/(?x-mi:a(?m:b))/, 'ruby/1.8')

    assert_equal false, t.expressions[0].m?
    assert_equal false, t.expressions[0].i?
    assert_equal true,  t.expressions[0].x?

    assert_equal true,  t.expressions[0].expressions[1].m?
    assert_equal false, t.expressions[0].expressions[1].i?
    assert_equal true,  t.expressions[0].expressions[1].x?

    assert_equal true,  t.expressions[0].expressions[1].option_changes[:m]
    assert_equal nil,   t.expressions[0].expressions[1].option_changes[:i]
    assert_equal nil,   t.expressions[0].expressions[1].option_changes[:x]
  end

  def test_parse_nested_options_deactivate_one
    t = RP.parse(/(?ix-m:a(?-i:b))/, 'ruby/1.8')

    assert_equal false, t.expressions[0].m?
    assert_equal true,  t.expressions[0].i?
    assert_equal true,  t.expressions[0].x?

    assert_equal false, t.expressions[0].expressions[1].m?
    assert_equal false, t.expressions[0].expressions[1].i?
    assert_equal true,  t.expressions[0].expressions[1].x?

    assert_equal false, t.expressions[0].expressions[1].option_changes[:i]
    assert_equal nil,   t.expressions[0].expressions[1].option_changes[:m]
    assert_equal nil,   t.expressions[0].expressions[1].option_changes[:x]
  end

  def test_parse_nested_options_invert_all
    t = RP.parse('(?xi-m:a(?m-ix:b))', 'ruby/1.8')

    assert_equal false, t.expressions[0].m?
    assert_equal true,  t.expressions[0].i?
    assert_equal true,  t.expressions[0].x?

    assert_equal true,  t.expressions[0].expressions[1].m?
    assert_equal false, t.expressions[0].expressions[1].i?
    assert_equal false, t.expressions[0].expressions[1].x?

    assert_equal true,  t.expressions[0].expressions[1].option_changes[:m]
    assert_equal false, t.expressions[0].expressions[1].option_changes[:i]
    assert_equal false, t.expressions[0].expressions[1].option_changes[:x]
  end

  def test_parse_nested_options_affect_literal_subexpressions
    t = RP.parse(/(?x-mi:a(?m:b))/, 'ruby/1.8')

    # a
    assert_equal false, t.expressions[0].expressions[0].m?
    assert_equal false, t.expressions[0].expressions[0].i?
    assert_equal true,  t.expressions[0].expressions[0].x?

    # b
    assert_equal true,  t.expressions[0].expressions[1].expressions[0].m?
    assert_equal false, t.expressions[0].expressions[1].expressions[0].i?
    assert_equal true,  t.expressions[0].expressions[1].expressions[0].x?
  end

  def test_parse_option_switch_group
    t = RP.parse(/a(?i-m)b/m, 'ruby/1.8')

    assert_equal Group::Options,  t.expressions[1].class
    assert_equal :options_switch, t.expressions[1].token

    assert_equal false, t.expressions[1].m?
    assert_equal true,  t.expressions[1].i?
    assert_equal false, t.expressions[1].x?

    assert_equal true,  t.expressions[1].option_changes[:i]
    assert_equal false, t.expressions[1].option_changes[:m]
    assert_equal nil,   t.expressions[1].option_changes[:x]
  end

  def test_parse_option_switch_affects_following_expressions
    t = RP.parse(/a(?i-m)b/m, 'ruby/1.8')

    # a
    assert_equal true,  t.expressions[0].m?
    assert_equal false, t.expressions[0].i?
    assert_equal false, t.expressions[0].x?

    # b
    assert_equal false, t.expressions[2].m?
    assert_equal true,  t.expressions[2].i?
    assert_equal false, t.expressions[2].x?
  end

  def test_parse_option_switch_in_group
    t = RP.parse(/(a(?i-m)b)c/m, 'ruby/1.8')

    group1 = t.expressions[0]

    assert_equal true,  group1.m?
    assert_equal false, group1.i?
    assert_equal false, group1.x?

    # a
    assert_equal true,  group1.expressions[0].m?
    assert_equal false, group1.expressions[0].i?
    assert_equal false, group1.expressions[0].x?

    # (?i-m)
    assert_equal false, group1.expressions[1].m?
    assert_equal true,  group1.expressions[1].i?
    assert_equal false, group1.expressions[1].x?

    # b
    assert_equal false, group1.expressions[2].m?
    assert_equal true,  group1.expressions[2].i?
    assert_equal false, group1.expressions[2].x?

    # c
    assert_equal true,  t.expressions[1].m?
    assert_equal false, t.expressions[1].i?
    assert_equal false, t.expressions[1].x?
  end

  def test_parse_nested_option_switch_in_group
    t = RP.parse(/((?i-m)(a(?-i)b))/m, 'ruby/1.8')

    group2 = t.expressions[0].expressions[1]

    assert_equal false, group2.m?
    assert_equal true,  group2.i?
    assert_equal false, group2.x?

    # a
    assert_equal false, group2.expressions[0].m?
    assert_equal true,  group2.expressions[0].i?
    assert_equal false, group2.expressions[0].x?

    # (?-i)
    assert_equal false, group2.expressions[1].m?
    assert_equal false, group2.expressions[1].i?
    assert_equal false, group2.expressions[1].x?

    # b
    assert_equal false, group2.expressions[2].m?
    assert_equal false, group2.expressions[2].i?
    assert_equal false, group2.expressions[2].x?
  end

  if RUBY_VERSION >= '2.0'
    def test_parse_options_dau
      t = RP.parse('(?dua:abc)')

      assert_equal false, t.expressions[0].d?
      assert_equal true,  t.expressions[0].a?
      assert_equal false, t.expressions[0].u?
    end

    def test_parse_nested_options_dau
      t = RP.parse('(?u:a(?d:b))')

      assert_equal true,  t.expressions[0].u?
      assert_equal false, t.expressions[0].d?
      assert_equal false, t.expressions[0].a?

      assert_equal true,  t.expressions[0].expressions[1].d?
      assert_equal false, t.expressions[0].expressions[1].a?
      assert_equal false, t.expressions[0].expressions[1].u?
    end

    def test_parse_nested_options_da
      t = RP.parse('(?di-xm:a(?da-x:b))')

      assert_equal true,  t.expressions[0].d?
      assert_equal true,  t.expressions[0].i?
      assert_equal false, t.expressions[0].m?
      assert_equal false, t.expressions[0].x?
      assert_equal false, t.expressions[0].a?
      assert_equal false, t.expressions[0].u?

      assert_equal false, t.expressions[0].expressions[1].d?
      assert_equal true,  t.expressions[0].expressions[1].a?
      assert_equal false, t.expressions[0].expressions[1].u?
      assert_equal false, t.expressions[0].expressions[1].x?
      assert_equal false, t.expressions[0].expressions[1].m?
      assert_equal true,  t.expressions[0].expressions[1].i?
    end
  end

  def test_parse_lookahead
    t = RP.parse('(?=abc)(?!def)', 'ruby/1.8')

    assert t.expressions[0].is_a?(Assertion::Lookahead),
           "Expected lookahead, but got #{t.expressions[0].class.name}"

    assert t.expressions[1].is_a?(Assertion::NegativeLookahead),
           "Expected negative lookahead, but got #{t.expressions[0].class.name}"
  end

  def test_parse_lookbehind
    t = RP.parse('(?<=abc)(?<!def)', 'ruby/1.9')

    assert t.expressions[0].is_a?(Assertion::Lookbehind),
           "Expected lookbehind, but got #{t.expressions[0].class.name}"

    assert t.expressions[1].is_a?(Assertion::NegativeLookbehind),
           "Expected negative lookbehind, but got #{t.expressions[0].class.name}"
  end

  def test_parse_comment
    t = RP.parse('a(?# is for apple)b(?# for boy)c(?# cat)')

    [1,3,5].each do |i|
      assert t.expressions[i].is_a?(Group::Comment),
             "Expected comment, but got #{t.expressions[i].class.name}"

      assert_equal :group,   t.expressions[i].type
      assert_equal :comment, t.expressions[i].token
    end
  end

  if RUBY_VERSION >= '2.4.1'
    def test_parse_absence_group
      t = RP.parse('a(?~b)c(?~d)e')

      [1,3].each do |i|
        assert t.expressions[i].is_a?(Group::Absence),
               "Expected absence group, but got #{t.expressions[i].class.name}"

        assert_equal :group,   t.expressions[i].type
        assert_equal :absence, t.expressions[i].token
      end
    end
  end

  def test_parse_group_number
    t = RP.parse('(a)(?=b)((?:c)(d|(e)))')
    assert_equal 1,     t[0].number
    assert_equal false, t[1].respond_to?(:number)
    assert_equal 2,     t[2].number
    assert_equal false, t[2][0].respond_to?(:number)
    assert_equal 3,     t[2][1].number
    assert_equal 4,     t[2][1][0][1][0].number
  end

  def test_parse_group_number_at_level
    t = RP.parse('(a)(?=b)((?:c)(d|(e)))')
    assert_equal 1,     t[0].number_at_level
    assert_equal false, t[1].respond_to?(:number_at_level)
    assert_equal 2,     t[2].number_at_level
    assert_equal false, t[2][0].respond_to?(:number_at_level)
    assert_equal 1,     t[2][1].number_at_level
    assert_equal 1,     t[2][1][0][1][0].number_at_level
  end
end
