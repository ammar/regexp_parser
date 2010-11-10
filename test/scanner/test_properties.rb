require File.expand_path("../../helpers", __FILE__)

class ScannerProperties < Test::Unit::TestCase

  tests = {
    'Alnum'     => :alnum,
    'Alpha'     => :alpha,
    'Any'       => :any,
    'Ascii'     => :ascii,
    'Blank'     => :blank,
    'Cntrl'     => :cntrl,
    'Digit'     => :digit,
    'Graph'     => :graph,
    'Lower'     => :lower,
    'Newline'   => :newline,
    'Print'     => :print,
    'Punct'     => :punct,
    'Space'     => :space,
    'Upper'     => :upper,
    'Word'      => :word,
    'Xdigit'    => :xdigit,

    'L'         => :letter_any,
    'Lu'        => :letter_uppercase,
    'Ll'        => :letter_lowercase,
    'Lt'        => :letter_titlecase,
    'Lm'        => :letter_modifier,
    'Lo'        => :letter_other,
    'M'         => :mark_any,
    'Mn'        => :mark_nonspacing,
    'Mc'        => :mark_spacing,
    'Me'        => :mark_enclosing,
    'N'         => :number_any,
    'Nd'        => :number_decimal,
    'Nl'        => :number_letter,
    'No'        => :number_other,
    'P'         => :punct_any,
    'Pc'        => :punct_connector,
    'Pd'        => :punct_dash,
    'Ps'        => :punct_open,
    'Pe'        => :punct_close,
    'Pi'        => :punct_initial,
    'Pf'        => :punct_final,
    'Po'        => :punct_other,
    'S'         => :symbol_any,
    'Sm'        => :symbol_math,
    'Sc'        => :symbol_currency,
    'Sk'        => :symbol_modifier,
    'So'        => :symbol_other,
    'Z'         => :separator_any,
    'Zs'        => :separator_space,
    'Zl'        => :separator_line,
    'Zp'        => :separator_para,
    'C'         => :cp_any,
    'Cc'        => :cp_control,
    'Cf'        => :cp_format,
    'Cs'        => :cp_surrogate,
    'Co'        => :cp_private,
    'Cn'        => :cp_unassigned,

    # derived
    'Math'                          => :derived_math,
    'Alphabetic'                    => :derived_alphabetic,
    'Lowercase'                     => :derived_lowercase,
    'Uppercase'                     => :derived_uppercase,
    'ID_Start'                      => :derived_id_start,
    'ID_Continue'                   => :derived_id_continue,
    'XID_Start'                     => :derived_xid_start,
    'XID_Continue'                  => :derived_xid_continue,
    'Default_Ignorable_Code_Point'  => :derived_default_ignorable_cp,
    'Grapheme_Base'                 => :derived_grapheme_base,
    'Grapheme_Extend'               => :derived_grapheme_extend,

    # Age
    'Age=1.1' => :age_1_1,
    'Age=2.0' => :age_2_0,
    'Age=2.1' => :age_2_1,
    'Age=3.0' => :age_3_0,
    'Age=3.1' => :age_3_1,
    'Age=3.2' => :age_3_2,
    'Age=4.0' => :age_4_0,
    'Age=4.1' => :age_4_1,
    'Age=5.0' => :age_5_0,
    'Age=5.1' => :age_5_1,
    'Age=5.2' => :age_5_2,
    'Age=6.0' => :age_6_0,
  }

  count = 0
  tests.each do |property, test|
    define_method "test_scan_property_#{test}_#{count+=1}" do
      token = RS.scan("a\\p{#{property}}c")[1]

      assert_equal( :property,  token[0] )
      assert_equal( test,       token[1] )
    end

    define_method "test_scan_nonproperty_#{test}_#{count+=1}" do
      token = RS.scan("a\\P{#{property}}c")[1]

      assert_equal( :nonproperty,   token[0] )
      assert_equal( test,           token[1] )
    end
  end

end
