require File.expand_path("../../helpers", __FILE__)

class ScannerProperties < Test::Unit::TestCase

  tests = {
    'Alnum'                               => :alnum,
    'Alpha'                               => :alpha,
    'Ascii'                               => :ascii,
    'Blank'                               => :blank,
    'Cntrl'                               => :cntrl,
    'Digit'                               => :digit,
    'Graph'                               => :graph,
    'Lower'                               => :lower,
    'Print'                               => :print,
    'Punct'                               => :punct,
    'Space'                               => :space,
    'Upper'                               => :upper,
    'Word'                                => :word,
    'Xdigit'                              => :xdigit,
    'XPosixPunct'                         => :xposixpunct,

    'Newline'                             => :newline,

    'Any'                                 => :any,
    'Assigned'                            => :assigned,

    'L'                                   => :letter_any,
    'Letter'                              => :letter_any,

    'Lu'                                  => :letter_uppercase,
    'Uppercase_Letter'                    => :letter_uppercase,

    'Ll'                                  => :letter_lowercase,
    'Lowercase_Letter'                    => :letter_lowercase,

    'Lt'                                  => :letter_titlecase,
    'Titlecase_Letter'                    => :letter_titlecase,

    'Lm'                                  => :letter_modifier,
    'Modifier_Letter'                     => :letter_modifier,

    'Lo'                                  => :letter_other,
    'Other_Letter'                        => :letter_other,

    'M'                                   => :mark_any,
    'Mark'                                => :mark_any,

    'Mn'                                  => :mark_nonspacing,
    'Nonspacing_Mark'                     => :mark_nonspacing,

    'Mc'                                  => :mark_spacing,
    'Spacing_Mark'                        => :mark_spacing,

    'Me'                                  => :mark_enclosing,
    'Enclosing_Mark'                      => :mark_enclosing,

    'N'                                   => :number_any,
    'Number'                              => :number_any,

    'Nd'                                  => :number_decimal,
    'Decimal_Number'                      => :number_decimal,

    'Nl'                                  => :number_letter,
    'Letter_Number'                       => :number_letter,

    'No'                                  => :number_other,
    'Other_Number'                        => :number_other,

    'P'                                   => :punct_any,
    'Punctuation'                         => :punct_any,

    'Pc'                                  => :punct_connector,
    'Connector_Punctuation'               => :punct_connector,

    'Pd'                                  => :punct_dash,
    'Dash_Punctuation'                    => :punct_dash,

    'Ps'                                  => :punct_open,
    'Open_Punctuation'                    => :punct_open,

    'Pe'                                  => :punct_close,
    'Close_Punctuation'                   => :punct_close,

    'Pi'                                  => :punct_initial,
    'Initial_Punctuation'                 => :punct_initial,

    'Pf'                                  => :punct_final,
    'Final_Punctuation'                   => :punct_final,

    'Po'                                  => :punct_other,
    'Other_Punctuation'                   => :punct_other,

    'S'                                   => :symbol_any,
    'Symbol'                              => :symbol_any,

    'Sm'                                  => :symbol_math,
    'Math_Symbol'                         => :symbol_math,

    'Sc'                                  => :symbol_currency,
    'Currency_Symbol'                     => :symbol_currency,

    'Sk'                                  => :symbol_modifier,
    'Modifier_Symbol'                     => :symbol_modifier,

    'So'                                  => :symbol_other,
    'Other_Symbol'                        => :symbol_other,

    'Z'                                   => :separator_any,
    'Separator'                           => :separator_any,

    'Zs'                                  => :separator_space,
    'Space_Separator'                     => :separator_space,

    'Zl'                                  => :separator_line,
    'Line_Separator'                      => :separator_line,

    'Zp'                                  => :separator_para,
    'Paragraph_Separator'                 => :separator_para,

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

    'Age=1.1'                             => :age_1_1,
    'Age=2.0'                             => :age_2_0,
    'Age=2.1'                             => :age_2_1,
    'Age=3.0'                             => :age_3_0,
    'Age=3.1'                             => :age_3_1,
    'Age=3.2'                             => :age_3_2,
    'Age=4.0'                             => :age_4_0,
    'Age=4.1'                             => :age_4_1,
    'Age=5.0'                             => :age_5_0,
    'Age=5.1'                             => :age_5_1,
    'Age=5.2'                             => :age_5_2,
    'Age=6.0'                             => :age_6_0,
    'Age=6.1'                             => :age_6_1,
    'Age=6.2'                             => :age_6_2,
    'Age=6.3'                             => :age_6_3,
    'Age=7.0'                             => :age_7_0,
    'Age=8.0'                             => :age_8_0,
    'Age=9.0'                             => :age_9_0,
    'Age=10.0'                            => :age_10_0,

    'ahex'                                => :ascii_hex,
    'ASCII_Hex_Digit'                     => :ascii_hex,

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

    'di'                                  => :default_ignorable_cp,
    'Default_Ignorable_Code_Point'        => :default_ignorable_cp,

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

    'idsb'                                => :ids_binary_op,
    'IDS_Binary_Operator'                 => :ids_binary_op,

    'idst'                                => :ids_trinary_op,
    'IDS_Trinary_Operator'                => :ids_trinary_op,

    'joinc'                               => :join_control,
    'Join_Control'                        => :join_control,

    'loe'                                 => :logical_order_exception,
    'Logical_Order_Exception'             => :logical_order_exception,

    'Lowercase'                           => :lowercase,

    'Math'                                => :math,

    'nchar'                               => :non_character_cp,
    'Noncharacter_Code_Point'             => :non_character_cp,

    'oalpha'                              => :other_alphabetic,
    'Other_Alphabetic'                    => :other_alphabetic,

    'odi'                                 => :other_default_ignorable_cp,
    'Other_Default_Ignorable_Code_Point'  => :other_default_ignorable_cp,

    'ogrext'                              => :other_grapheme_extended,
    'Other_Grapheme_Extend'               => :other_grapheme_extended,

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

    'patws'                               => :pattern_whitespace,
    'Pattern_Whitespace'                  => :pattern_whitespace,

    'qmark'                               => :quotation_mark,
    'quotationmark'                       => :quotation_mark,

    'radical'                             => :radical,

    'ri'                                  => :regional_indicator,
    'Regional_Indicator'                  => :regional_indicator,

    'sd'                                  => :soft_dotted,
    'Soft_Dotted'                         => :soft_dotted,

    'sterm'                               => :sentence_terminal,

    'term'                                => :terminal_punctuation,
    'Terminal_Punctuation'                => :terminal_punctuation,

    'uideo'                               => :unified_ideograph,
    'Unified_Ideograph'                   => :unified_ideograph,

    'Uppercase'                           => :uppercase,

    'vs'                                  => :variation_selector,
    'Variation_Selector'                  => :variation_selector,

    'wspace'                              => :whitespace,
    'whitespace'                          => :whitespace,

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
