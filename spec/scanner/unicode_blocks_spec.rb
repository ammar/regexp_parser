require 'spec_helper'

RSpec.describe('UnicodeBlock scanning') do
  include_examples 'scan property', 'InArabic',                               :in_arabic
  include_examples 'scan property', 'InCJK_Unified_Ideographs_Extension_A',   :in_cjk_unified_ideographs_extension_a
  include_examples 'scan property', 'In Letterlike Symbols',                  :in_letterlike_symbols
  include_examples 'scan property', 'InMiscellaneous_Mathematical_Symbols-A', :in_miscellaneous_mathematical_symbols_a
end
