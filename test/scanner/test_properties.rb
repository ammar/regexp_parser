require File.expand_path("../../helpers", __FILE__)

class ScannerProperties < Test::Unit::TestCase

  tests = {
    'Alnum'                               => :alnum,

    'XPosixPunct'                         => :xposixpunct,

    'Newline'                             => :newline,

    'Any'                                 => :any,

    'Assigned'                            => :assigned,

    'L'                                   => :letter,
    'Letter'                              => :letter,

    'Lu'                                  => :uppercase_letter,
    'Uppercase_Letter'                    => :uppercase_letter,

    'Ll'                                  => :lowercase_letter,
    'Lowercase_Letter'                    => :lowercase_letter,

    'Lt'                                  => :titlecase_letter,
    'Titlecase_Letter'                    => :titlecase_letter,

    'Lm'                                  => :modifier_letter,
    'Modifier_Letter'                     => :modifier_letter,

    'Lo'                                  => :other_letter,
    'Other_Letter'                        => :other_letter,

    'M'                                   => :mark,
    'Mark'                                => :mark,

    'Mn'                                  => :nonspacing_mark,
    'Nonspacing_Mark'                     => :nonspacing_mark,

    'Mc'                                  => :spacing_mark,
    'Spacing_Mark'                        => :spacing_mark,

    'Me'                                  => :enclosing_mark,
    'Enclosing_Mark'                      => :enclosing_mark,

    'N'                                   => :number,
    'Number'                              => :number,

    'Nd'                                  => :decimal_number,
    'Decimal_Number'                      => :decimal_number,

    'Nl'                                  => :letter_number,
    'Letter_Number'                       => :letter_number,

    'No'                                  => :other_number,
    'Other_Number'                        => :other_number,

    'P'                                   => :punctuation,
    'Punctuation'                         => :punctuation,

    'Pc'                                  => :connector_punctuation,
    'Connector_Punctuation'               => :connector_punctuation,

    'Pd'                                  => :dash_punctuation,
    'Dash_Punctuation'                    => :dash_punctuation,

    'Ps'                                  => :open_punctuation,
    'Open_Punctuation'                    => :open_punctuation,

    'Pe'                                  => :close_punctuation,
    'Close_Punctuation'                   => :close_punctuation,

    'Pi'                                  => :initial_punctuation,
    'Initial_Punctuation'                 => :initial_punctuation,

    'Pf'                                  => :final_punctuation,
    'Final_Punctuation'                   => :final_punctuation,

    'Po'                                  => :other_punctuation,
    'Other_Punctuation'                   => :other_punctuation,

    'S'                                   => :symbol,
    'Symbol'                              => :symbol,

    'Sm'                                  => :math_symbol,
    'Math_Symbol'                         => :math_symbol,

    'Sc'                                  => :currency_symbol,
    'Currency_Symbol'                     => :currency_symbol,

    'Sk'                                  => :modifier_symbol,
    'Modifier_Symbol'                     => :modifier_symbol,

    'So'                                  => :other_symbol,
    'Other_Symbol'                        => :other_symbol,

    'Z'                                   => :separator,
    'Separator'                           => :separator,

    'Zs'                                  => :space_separator,
    'Space_Separator'                     => :space_separator,

    'Zl'                                  => :line_separator,
    'Line_Separator'                      => :line_separator,

    'Zp'                                  => :paragraph_separator,
    'Paragraph_Separator'                 => :paragraph_separator,

    'C'                                   => :other,
    'Other'                               => :other,

    'Cc'                                  => :control,
    'Control'                             => :control,

    'Cf'                                  => :format,
    'Format'                              => :format,

    'Cs'                                  => :surrogate,
    'Surrogate'                           => :surrogate,

    'Co'                                  => :private_use,
    'Private_Use'                         => :private_use,

    'Cn'                                  => :unassigned,
    'Unassigned'                          => :unassigned,

    'Age=1.1'                             => :'age=1.1',
    'Age=6.0'                             => :'age=6.0',
    'Age=10.0'                            => :'age=10.0',

    'ahex'                                => :ascii_hex_digit,
    'ASCII_Hex_Digit'                     => :ascii_hex_digit,

    'Alphabetic'                          => :alphabetic,

    'Cased'                               => :cased,

    'cwcf'                                => :changes_when_casefolded,
    'Changes_When_Casefolded'             => :changes_when_casefolded,

    'cwcm'                                => :changes_when_casemapped,
    'Changes_When_Casemapped'             => :changes_when_casemapped,

    'cwl'                                 => :changes_when_lowercased,
    'Changes_When_Lowercased'             => :changes_when_lowercased,

    'cwt'                                 => :changes_when_titlecased,
    'Changes_When_Titlecased'             => :changes_when_titlecased,

    'cwu'                                 => :changes_when_uppercased,
    'Changes_When_Uppercased'             => :changes_when_uppercased,

    'ci'                                  => :case_ignorable,
    'Case_Ignorable'                      => :case_ignorable,

    'bidic'                               => :bidi_control,
    'Bidi_Control'                        => :bidi_control,

    'Dash'                                => :dash,

    'dep'                                 => :deprecated,
    'Deprecated'                          => :deprecated,

    'di'                                  => :default_ignorable_code_point,
    'Default_Ignorable_Code_Point'        => :default_ignorable_code_point,

    'dia'                                 => :diacritic,
    'Diacritic'                           => :diacritic,

    'ext'                                 => :extender,
    'Extender'                            => :extender,

    'grbase'                              => :grapheme_base,
    'Grapheme_Base'                       => :grapheme_base,

    'grext'                               => :grapheme_extend,
    'Grapheme_Extend'                     => :grapheme_extend,

    'grlink'                              => :grapheme_link,
    'Grapheme_Link'                       => :grapheme_link,

    'hex'                                 => :hex_digit,
    'Hex_Digit'                           => :hex_digit,

    'Hyphen'                              => :hyphen,

    'idc'                                 => :id_continue,
    'ID_Continue'                         => :id_continue,

    'ideo'                                => :ideographic,
    'Ideographic'                         => :ideographic,

    'ids'                                 => :id_start,
    'ID_Start'                            => :id_start,

    'idsb'                                => :ids_binary_operator,
    'IDS_Binary_Operator'                 => :ids_binary_operator,

    'idst'                                => :ids_trinary_operator,
    'IDS_Trinary_Operator'                => :ids_trinary_operator,

    'joinc'                               => :join_control,
    'Join_Control'                        => :join_control,

    'loe'                                 => :logical_order_exception,
    'Logical_Order_Exception'             => :logical_order_exception,

    'Lowercase'                           => :lowercase,

    'Math'                                => :math,

    'nchar'                               => :noncharacter_code_point,
    'Noncharacter_Code_Point'             => :noncharacter_code_point,

    'oalpha'                              => :other_alphabetic,
    'Other_Alphabetic'                    => :other_alphabetic,

    'odi'                                 => :other_default_ignorable_code_point,
    'Other_Default_Ignorable_Code_Point'  => :other_default_ignorable_code_point,

    'ogrext'                              => :other_grapheme_extend,
    'Other_Grapheme_Extend'               => :other_grapheme_extend,

    'oidc'                                => :other_id_continue,
    'Other_ID_Continue'                   => :other_id_continue,

    'oids'                                => :other_id_start,
    'Other_ID_Start'                      => :other_id_start,

    'olower'                              => :other_lowercase,
    'Other_Lowercase'                     => :other_lowercase,

    'omath'                               => :other_math,
    'Other_Math'                          => :other_math,

    'oupper'                              => :other_uppercase,
    'Other_Uppercase'                     => :other_uppercase,

    'patsyn'                              => :pattern_syntax,
    'Pattern_Syntax'                      => :pattern_syntax,

    'patws'                               => :pattern_white_space,
    'Pattern_Whitespace'                  => :pattern_white_space,

    'qmark'                               => :quotation_mark,
    'quotationmark'                       => :quotation_mark,

    'radical'                             => :radical,

    'ri'                                  => :regional_indicator,
    'Regional_Indicator'                  => :regional_indicator,

    'sd'                                  => :soft_dotted,
    'Soft-Dotted'                         => :soft_dotted, # test dash spelling

    'sterm'                               => :sentence_terminal,

    'term'                                => :terminal_punctuation,
    'Terminal_Punctuation'                => :terminal_punctuation,

    'uideo'                               => :unified_ideograph,
    'Unified_Ideograph'                   => :unified_ideograph,

    'Uppercase'                           => :uppercase,

    'vs'                                  => :variation_selector,
    'Variation_Selector'                  => :variation_selector,

    'wspace'                              => :white_space,
    'whitespace'                          => :white_space,

    'xids'                                => :xid_start,
    'XID_Start'                           => :xid_start,

    'xidc'                                => :xid_continue,
    'XID_Continue'                        => :xid_continue,
  }

  tests.each_with_index do |(property, token), count|
    define_method "test_scan_property_#{token}_#{count}" do
      tokens = RS.scan("a\\p{#{property}}c")
      result = tokens.at(1)

      assert_equal :property, result[0]
      assert_equal token,     result[1]
    end

    define_method "test_scan_nonproperty_#{token}_#{count}" do
      tokens = RS.scan("a\\P{#{property}}c")
      result = tokens.at(1)

      assert_equal :nonproperty, result[0]
      assert_equal token,        result[1]
    end

    define_method "test_scan_caret_nonproperty_#{token}_#{count}" do
      tokens = RS.scan("a\\p{^#{property}}c")
      result = tokens.at(1)

      assert_equal :nonproperty, result[0]
      assert_equal token,        result[1]
    end

    define_method "test_scan_double_negated_property_#{token}_#{count}" do
      tokens = RS.scan("a\\P{^#{property}}c")
      result = tokens.at(1)

      assert_equal :property, result[0]
      assert_equal token,     result[1]
    end
  end
end
