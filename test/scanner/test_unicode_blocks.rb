require File.expand_path("../../helpers", __FILE__)

class ScannerUnicodeBlocks < Test::Unit::TestCase

  tests = {
    'InAlphabetic_Presentation_Forms'           => :block_inalphabetic_presentation_forms,
    'InArabic_Presentation_Forms-A'             => :block_inarabic_presentation_forms_a,
    'InArabic_Presentation_Forms-B'             => :block_inarabic_presentation_forms_b,
    'InArabic'                                  => :block_inarabic,
    'InArmenian'                                => :block_inarmenian,
    'InArrows'                                  => :block_inarrows,
    'InBasic_Latin'                             => :block_inbasic_latin,
    'InBengali'                                 => :block_inbengali,
    'InBlock_Elements'                          => :block_inblock_elements,
    'InBopomofo_Extended'                       => :block_inbopomofo_extended,
    'InBopomofo'                                => :block_inbopomofo,
    'InBox_Drawing'                             => :block_inbox_drawing,
    'InBraille_Patterns'                        => :block_inbraille_patterns,
    'InBuhid'                                   => :block_inbuhid,
    'InCJK_Compatibility_Forms'                 => :block_incjk_compatibility_forms,
    'InCJK_Compatibility_Ideographs'            => :block_incjk_compatibility_ideographs,
    'InCJK_Compatibility'                       => :block_incjk_compatibility,
    'InCJK_Radicals_Supplement'                 => :block_incjk_radicals_supplement,
    'InCJK_Symbols_and_Punctuation'             => :block_incjk_symbols_and_punctuation,
    'InCJK_Unified_Ideographs_Extension_A'      => :block_incjk_unified_ideographs_extension_a,
    'InCJK_Unified_Ideographs'                  => :block_incjk_unified_ideographs,
    'InCherokee'                                => :block_incherokee,
    'InCombining_Diacritical_Marks_for_Symbols' => :block_incombining_diacritical_marks_for_symbols,
    'InCombining_Diacritical_Marks'             => :block_incombining_diacritical_marks,
    'InCombining_Half_Marks'                    => :block_incombining_half_marks,
    'InControl_Pictures'                        => :block_incontrol_pictures,
    'InCurrency_Symbols'                        => :block_incurrency_symbols,
    'InCyrillic_Supplement'                     => :block_incyrillic_supplement,
    'InCyrillic'                                => :block_incyrillic,
    'InDevanagari'                              => :block_indevanagari,
    'InDingbats'                                => :block_indingbats,
    'InEnclosed_Alphanumerics'                  => :block_inenclosed_alphanumerics,
    'InEnclosed_CJK_Letters_and_Months'         => :block_inenclosed_cjk_letters_and_months,
    'InEthiopic'                                => :block_inethiopic,
    'InGeneral_Punctuation'                     => :block_ingeneral_punctuation,
    'InGeometric_Shapes'                        => :block_ingeometric_shapes,
    'InGeorgian'                                => :block_ingeorgian,
    'InGreek_Extended'                          => :block_ingreek_extended,
    'InGreek_and_Coptic'                        => :block_ingreek_and_coptic,
    'InGujarati'                                => :block_ingujarati,
    'InGurmukhi'                                => :block_ingurmukhi,
    'InHalfwidth_and_Fullwidth_Forms'           => :block_inhalfwidth_and_fullwidth_forms,
    'InHangul_Compatibility_Jamo'               => :block_inhangul_compatibility_jamo,
    'InHangul_Jamo'                             => :block_inhangul_jamo,
    'InHangul_Syllables'                        => :block_inhangul_syllables,
    'InHanunoo'                                 => :block_inhanunoo,
    'InHebrew'                                  => :block_inhebrew,
    'InHigh_Private_Use_Surrogates'             => :block_inhigh_private_use_surrogates,
    'InHigh_Surrogates'                         => :block_inhigh_surrogates,
    'InHiragana'                                => :block_inhiragana,
    'InIPA_Extensions'                          => :block_inipa_extensions,
    'InIdeographic_Description_Characters'      => :block_inideographic_description_characters,
    'InKanbun'                                  => :block_inkanbun,
    'InKangxi_Radicals'                         => :block_inkangxi_radicals,
    'InKannada'                                 => :block_inkannada,
    'InKatakana_Phonetic_Extensions'            => :block_inkatakana_phonetic_extensions,
    'InKatakana'                                => :block_inkatakana,
    'InKhmer_Symbols'                           => :block_inkhmer_symbols,
    'InKhmer'                                   => :block_inkhmer,
    'InLao'                                     => :block_inlao,
    'InLatin-1_Supplement'                      => :block_inlatin_1_supplement,
    'InLatin_Extended-A'                        => :block_inlatin_extended_a,
    'InLatin_Extended-B'                        => :block_inlatin_extended_b,
    'InLatin_Extended_Additional'               => :block_inlatin_extended_additional,
    'InLetterlike_Symbols'                      => :block_inletterlike_symbols,
    'InLimbu'                                   => :block_inlimbu,
    'InLow_Surrogates'                          => :block_inlow_surrogates,
    'InMalayalam'                               => :block_inmalayalam,
    'InMathematical_Operators'                  => :block_inmathematical_operators,
    'InMiscellaneous_Mathematical_Symbols-A'    => :block_inmiscellaneous_mathematical_symbols_a,
    'InMiscellaneous_Mathematical_Symbols-B'    => :block_inmiscellaneous_mathematical_symbols_b,
    'InMiscellaneous_Symbols_and_Arrows'        => :block_inmiscellaneous_symbols_and_arrows,
    'InMiscellaneous_Symbols'                   => :block_inmiscellaneous_symbols,
    'InMiscellaneous_Technical'                 => :block_inmiscellaneous_technical,
    'InMongolian'                               => :block_inmongolian,
    'InMyanmar'                                 => :block_inmyanmar,
    'InNumber_Forms'                            => :block_innumber_forms,
    'InOgham'                                   => :block_inogham,
    'InOptical_Character_Recognition'           => :block_inoptical_character_recognition,
    'InOriya'                                   => :block_inoriya,
    'InPhonetic_Extensions'                     => :block_inphonetic_extensions,
    'InPrivate_Use_Area'                        => :block_inprivate_use_area,
    'InRunic'                                   => :block_inrunic,
    'InSinhala'                                 => :block_insinhala,
    'InSmall_Form_Variants'                     => :block_insmall_form_variants,
    'InSpacing_Modifier_Letters'                => :block_inspacing_modifier_letters,
    'InSpecials'                                => :block_inspecials,
    'InSuperscripts_and_Subscripts'             => :block_insuperscripts_and_subscripts,
    'InSupplemental_Arrows-A'                   => :block_insupplemental_arrows_a,
    'InSupplemental_Arrows-B'                   => :block_insupplemental_arrows_b,
    'InSupplemental_Mathematical_Operators'     => :block_insupplemental_mathematical_operators,
    'InSyriac'                                  => :block_insyriac,
    'InTagalog'                                 => :block_intagalog,
    'InTagbanwa'                                => :block_intagbanwa,
    'InTai_Le'                                  => :block_intai_le,
    'InTamil'                                   => :block_intamil,
    'InTelugu'                                  => :block_intelugu,
    'InThaana'                                  => :block_inthaana,
    'InThai'                                    => :block_inthai,
    'InTibetan'                                 => :block_intibetan,
    'InUnified_Canadian_Aboriginal_Syllabics'   => :block_inunified_canadian_aboriginal_syllabics,
    'InVariation_Selectors'                     => :block_invariation_selectors,
    'InYi_Radicals'                             => :block_inyi_radicals,
    'InYi_Syllables'                            => :block_inyi_syllables,
    'InYijing_Hexagram_Symbols'                 => :block_inyijing_hexagram_symbols
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
