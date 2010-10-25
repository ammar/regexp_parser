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
