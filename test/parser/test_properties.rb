require File.expand_path("../../helpers", __FILE__)

class ParserProperties < Test::Unit::TestCase
  modes = ['p', 'P']
  example_props = [
    'Alnum',
    'Any',
    'Age=1.1',
    'Dash',
    'di',
    'Default_Ignorable_Code_Point',
    'Math',
    'Noncharacter-Code_Point', # test dash
    'sd',
    'Soft Dotted', # test whitespace
    'sterm',
    'xidc',
    'XID_Continue',
    'Emoji',
    'InChessSymbols',
  ]

  modes.each do |mode|
    token_type = mode == 'p' ? :property : :nonproperty

    example_props.each do |property|
      define_method "test_parse_#{token_type}_#{property}" do
        t = RP.parse "ab\\#{mode}{#{property}}", '*'

        assert t.expressions.last.is_a?(UnicodeProperty::Base),
               "Expected property, but got #{t.expressions.last.class.name}"

        assert_equal token_type, t.expressions.last.type
        assert_equal property,   t.expressions.last.name
      end
    end
  end

  def test_parse_all_properties_of_current_ruby
    unsupported = RegexpPropertyValues.all_for_current_ruby.reject do |prop|
      begin RP.parse("\\p{#{prop}}"); rescue SyntaxError, StandardError; nil end
    end
    assert_empty unsupported
  end

  def test_parse_property_negative
    t = RP.parse 'ab\p{L}cd', 'ruby/1.9'

    assert_equal false, t.expressions[1].negative?
  end

  def test_parse_nonproperty_negative
    t = RP.parse 'ab\P{L}cd', 'ruby/1.9'

    assert_equal true, t.expressions[1].negative?
  end

  def test_parse_caret_nonproperty_negative
    t = RP.parse 'ab\p{^L}cd', 'ruby/1.9'

    assert_equal true, t.expressions[1].negative?
  end

  def test_parse_double_negated_property_negative
    t = RP.parse 'ab\P{^L}cd', 'ruby/1.9'

    assert_equal false, t.expressions[1].negative?
  end

  def test_parse_property_shortcut
    assert_equal 'm',  RP.parse('\p{mark}').expressions[0].shortcut
    assert_equal 'sc', RP.parse('\p{sc}').expressions[0].shortcut
    assert_equal nil,  RP.parse('\p{in_bengali}').expressions[0].shortcut
  end

  def test_parse_property_age
    t = RP.parse 'ab\p{age=5.2}cd', 'ruby/1.9'

    assert t.expressions[1].is_a?(UnicodeProperty::Age),
           "Expected Age property, but got #{t.expressions[1].class.name}"
  end

  def test_parse_property_derived
    t = RP.parse 'ab\p{Math}cd', 'ruby/1.9'

    assert t.expressions[1].is_a?(UnicodeProperty::Derived),
           "Expected Derived property, but got #{t.expressions[1].class.name}"
  end

  def test_parse_property_script
    t = RP.parse 'ab\p{Hiragana}cd', 'ruby/1.9'

    assert t.expressions[1].is_a?(UnicodeProperty::Script),
           "Expected Script property, but got #{t.expressions[1].class.name}"
  end

  def test_parse_property_script_V1_9_3
    t = RP.parse 'ab\p{Brahmi}cd', 'ruby/1.9.3'

    assert t.expressions[1].is_a?(UnicodeProperty::Script),
           "Expected Script property, but got #{t.expressions[1].class.name}"
  end

  def test_parse_property_script_V2_2_0
    t = RP.parse 'ab\p{Caucasian_Albanian}cd', 'ruby/2.2'

    assert t.expressions[1].is_a?(UnicodeProperty::Script),
           "Expected Script property, but got #{t.expressions[1].class.name}"
  end

  def test_parse_property_block
    t = RP.parse 'ab\p{InArmenian}cd', 'ruby/1.9'

    assert t.expressions[1].is_a?(UnicodeProperty::Block),
           "Expected Block property, but got #{t.expressions[1].class.name}"
  end

  def test_parse_property_following_literal
    t = RP.parse 'ab\p{Lu}cd', 'ruby/1.9'

    assert t.expressions[2].is_a?(Literal),
           "Expected Literal, but got #{t.expressions[2].class.name}"
  end

  def test_parse_abandoned_newline_property
    t = RP.parse '\p{newline}', 'ruby/1.9'
    assert t.expressions.last.is_a?(UnicodeProperty::Base),
           "Expected property, but got #{t.expressions.last.class.name}"

    assert_raise(Regexp::Syntax::NotImplementedError) {
      RP.parse('\p{newline}', 'ruby/2.0')
    }
  end
end
