require 'spec_helper'

RSpec.describe('UnicodeBlock scanning') do
  tests = {
    'InArabic'                               => :in_arabic,
    'InCJK_Unified_Ideographs_Extension_A'   => :in_cjk_unified_ideographs_extension_a,
    'In Letterlike Symbols'                  => :in_letterlike_symbols,
    'InMiscellaneous_Mathematical_Symbols-A' => :in_miscellaneous_mathematical_symbols_a
  }

  tests.each_with_index do |(property, token), count|
    specify("scanner_property_#{token}_#{count}") do
      tokens = RS.scan("a\\p{#{property}}c")
      result = tokens.at(1)

      expect(result[0]).to eq :property
      expect(result[1]).to eq token
    end

    specify("scanner_nonproperty_#{token}_#{count}") do
      tokens = RS.scan("a\\P{#{property}}c")
      result = tokens.at(1)

      expect(result[0]).to eq :nonproperty
      expect(result[1]).to eq token
    end
  end
end
