require File.expand_path("../../helpers", __FILE__)

class ParserProperties < Test::Unit::TestCase

  modes = ['p', 'P']
  props = [
    'Alnum',
    'Alpha',
    'Any',
    'Ascii',
    'Blank',
    'Cntrl',
    'Digit',
    'Graph',
    'Lower',
    'Newline',
    'Print',
    'Punct',
    'Space',
    'Upper',
    'Word',
    'Xdigit',

    'L',
    'Letter',

    'Lu',
    'Uppercase_Letter',

    'Ll',
    'Lowercase_Letter',

    'Lt',
    'Titlecase_Letter',

    'Lm',
    'Modifier_Letter',

    'Lo',
    'Other_Letter',

    'M',
    'Mark',

    'Mn',
    'Nonspacing_Mark',

    'Mc',
    'Spacing_Mark',

    'Me',
    'Enclosing_Mark',

    'N',
    'Number',

    'Nd',
    'Decimal_Number',

    'Nl',
    'Letter_Number',

    'No',
    'Other_Number',

    'P',
    'Punctuation',

    'Pc',
    'Connector_Punctuation',

    'Pd',
    'Dash_Punctuation',

    'Ps',
    'Open_Punctuation',

    'Pe',
    'Close_Punctuation',

    'Pi',
    'Initial_Punctuation',

    'Pf',
    'Final_Punctuation',

    'Po',
    'Other_Punctuation',

    'S',
    'Symbol',

    'Sm',
    'Math_Symbol',

    'Sc',
    'Currency_Symbol',

    'Sk',
    'Modifier_Symbol',

    'So',
    'Other_Symbol',

    'Z',
    'Separator',

    'Zs',
    'Space_Separator',

    'Zl',
    'Line_Separator',

    'Zp',
    'Paragraph_Separator',

    'C',
    'Other',

    'Cc',
    'Control',

    'Cf',
    'Format',

    'Cs',
    'Surrogate',

    'Co',
    'Private_Use',

    'Cn',
    'Unassigned',

    'Age=1.1',
    'Age=2.0',
    'Age=2.1',
    'Age=3.0',
    'Age=3.1',
    'Age=3.2',
    'Age=4.0',
    'Age=4.1',
    'Age=5.0',
    'Age=5.1',
    'Age=5.2',
    'Age=6.0',

    'ahex',
    'ASCII_Hex_Digit',

    'Alphabetic',

    'Cased',

    'cwcf',
    'Changes_When_Casefolded',

    'cwcm',
    'Changes_When_Casemapped',

    'cwl',
    'Changes_When_Lowercased',

    'cwt',
    'Changes_When_Titlecased',

    'cwu',
    'Changes_When_Uppercased',

    'ci',
    'Case_Ignorable',

    'bidic',
    'Bidi_Control',

    'Dash',

    'dep',
    'Deprecated',

    'di',
    'Default_Ignorable_Code_Point',

    'dia',
    'Diacritic',

    'ext',
    'Extender',

    'grbase',
    'Grapheme_Base',

    'grext',
    'Grapheme_Extend',

    'grlink',
    'Grapheme_Link',

    'hex',
    'Hex_Digit',

    'Hyphen',

    'idc',
    'ID_Continue',

    'ideo',
    'Ideographic',

    'ids',
    'ID_Start',

    'idsb',
    'IDS_Binary_Operator',

    'idst',
    'IDS_Trinary_Operator',

    'joinc',
    'Join_Control',

    'loe',
    'Logical_Order_Exception',

    'Lowercase',

    'Math',

    'nchar',
    'Noncharacter_Code_Point',

    'oalpha',
    'Other_Alphabetic',

    'odi',
    'Other_Default_Ignorable_Code_Point',

    'ogrext',
    'Other_Grapheme_Extend',

    'oidc',
    'Other_ID_Continue',

    'oids',
    'Other_ID_Start',

    'olower',
    'Other_Lowercase',

    'omath',
    'Other_Math',

    'oupper',
    'Other_Uppercase',

    'patsyn',
    'Pattern_Syntax',

    'patws',
    'Pattern_Whitespace',

    'qmark',
    'quotationmark',

    'radical',

    'sd',
    'Soft_Dotted',

    'sterm',

    'term',
    'Terminal_Punctuation',

    'uideo',
    'Unified_Ideograph',

    'Uppercase',

    'vs',
    'Variation_Selector',

    'wspace',
    'whitespace',

    'xids',
    'XID_Start',

    'xidc',
    'XID_Continue',
  ]

  modes.each do |mode|
    token_type = mode == 'p' ? :property : :nonproperty

    props.each do |property|
      define_method "test_parse_#{token_type}_#{property}" do
        t = RP.parse "ab\\#{mode}{#{property}}", 'ruby/1.9'

        assert t.expressions.last.is_a?(UnicodeProperty::Base),
               "Expected property, but got #{t.expressions.last.class.name}"

        assert_equal token_type, t.expressions.last.type
        assert_equal property,   t.expressions.last.name
      end
    end
  end

  def test_parse_property_negative
    t = RP.parse 'ab\p{L}cd', 'ruby/1.9'

    assert_equal false, t.expressions[1].negative?
  end

  def test_parse_nonproperty_negative
    t = RP.parse 'ab\P{L}cd', 'ruby/1.9'

    assert_equal true, t.expressions[1].negative?
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
end
