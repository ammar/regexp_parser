require File.expand_path("../../helpers", __FILE__)

class ScannerUnicodeBlocks < Test::Unit::TestCase

  tests = {
    'InArabic'                                  => :in_arabic,
    'InCJK_Unified_Ideographs_Extension_A'      => :in_cjk_unified_ideographs_extension_a,
    'In Letterlike Symbols'                     => :in_letterlike_symbols,
    'InMiscellaneous_Mathematical_Symbols-A'    => :in_miscellaneous_mathematical_symbols_a,
  }

  tests.each_with_index do |(property, token), count|
    define_method "test_scanner_property_#{token}_#{count}" do
      tokens = RS.scan("a\\p{#{property}}c")
      result = tokens.at(1)

      assert_equal :property, result[0]
      assert_equal token,     result[1]
    end

    define_method "test_scanner_nonproperty_#{token}_#{count}" do
      tokens = RS.scan("a\\P{#{property}}c")
      result = tokens.at(1)

      assert_equal :nonproperty, result[0]
      assert_equal token,        result[1]
    end
  end

end
