module Regexp::Syntax
  module Token

    module UnicodeProperty
      CharType_V1_9_0 = [:alnum, :alpha, :ascii, :blank, :cntrl, :digit, :graph,
                       :lower, :print, :punct, :space, :upper, :word, :xdigit]

      CharType_V2_5_0 = [:xposixpunct]

      POSIX  = [:any, :assigned, :newline]

      module Category
        Letter        = [:letter_any, :letter_uppercase, :letter_lowercase,
                         :letter_titlecase, :letter_modifier, :letter_other]

        Mark          = [:mark_any, :mark_nonspacing, :mark_spacing,
                         :mark_enclosing]

        Number        = [:number_any, :number_decimal, :number_letter,
                         :number_other]

        Punctuation   = [:punct_any, :punct_connector, :punct_dash,
                         :punct_open, :punct_close, :punct_initial,
                         :punct_final, :punct_other]

        Symbol        = [:symbol_any, :symbol_math, :symbol_currency,
                         :symbol_modifier, :symbol_other]

        Separator     = [:separator_any, :separator_space, :separator_line,
                         :separator_para]

        Codepoint     = [:other, :control, :format,
                         :surrogate, :private_use, :unassigned]

        All = Letter + Mark + Number + Punctuation +
              Symbol + Separator + Codepoint
      end

      # As of ruby version 1.9.3
      Age_V1_9_3 = [:age_1_1, :age_2_0, :age_2_1, :age_3_0, :age_3_1,
                    :age_3_2, :age_4_0, :age_4_1, :age_5_0, :age_5_1,
                    :age_5_2, :age_6_0]

      Age_V2_0_0 = [:age_6_1]

      # These were merged (from Onigmo) in the branch for 2.2.0
      Age_V2_2_0 = [:age_6_2, :age_6_3, :age_7_0]

      Age_V2_3_0 = [:age_8_0]

      Age_V2_4_0 = [:age_9_0]

      Age_V2_5_0 = [:age_10_0]

      Age = Age_V1_9_3 + Age_V2_0_0 + Age_V2_2_0 + Age_V2_3_0 + Age_V2_4_0 + Age_V2_5_0

      Derived_V1_9_0 = [
        :ascii_hex,
        :alphabetic,
        :cased,
        :changes_when_casefolded,
        :changes_when_casemapped,
        :changes_when_lowercased,
        :changes_when_titlecased,
        :changes_when_uppercased,
        :case_ignorable,
        :bidi_control,
        :dash,
        :deprecated,
        :default_ignorable_cp,
        :diacritic,
        :extender,
        :grapheme_base,
        :grapheme_extend,
        :grapheme_link,
        :hex_digit,
        :hyphen,
        :id_continue,
        :ideographic,
        :id_start,
        :ids_binary_op,
        :ids_trinary_op,
        :join_control,
        :logical_order_exception,
        :lowercase,
        :math,
        :non_character_cp,
        :other_alphabetic,
        :other_default_ignorable_cp,
        :other_grapheme_extended,
        :other_id_continue,
        :other_id_start,
        :other_lowercase,
        :other_math,
        :other_uppercase,
        :pattern_syntax,
        :pattern_whitespace,
        :quotation_mark,
        :radical,
        :soft_dotted,
        :sentence_terminal,
        :terminal_punctuation,
        :unified_ideograph,
        :uppercase,
        :variation_selector,
        :whitespace,
        :xid_start,
        :xid_continue,
      ]

      Derived_V2_5_0 = [
        :regional_indicator
      ]

      Derived = Derived_V1_9_0 + Derived_V2_5_0

      Script_V1_9_0 = [
        :script_arabic,
        :script_imperial_aramaic,
        :script_armenian,
        :script_avestan,
        :script_balinese,
        :script_bamum,
        :script_bengali,
        :script_bopomofo,
        :script_braille,
        :script_buginese,
        :script_buhid,
        :script_canadian_aboriginal,
        :script_carian,
        :script_cham,
        :script_cherokee,
        :script_coptic,
        :script_cypriot,
        :script_cyrillic,
        :script_devanagari,
        :script_deseret,
        :script_egyptian_hieroglyphs,
        :script_ethiopic,
        :script_georgian,
        :script_glagolitic,
        :script_gothic,
        :script_greek,
        :script_gujarati,
        :script_gurmukhi,
        :script_hangul,
        :script_han,
        :script_hanunoo,
        :script_hebrew,
        :script_hiragana,
        :script_katakana_or_hiragana,
        :script_old_italic,
        :script_javanese,
        :script_kayah_li,
        :script_katakana,
        :script_kharoshthi,
        :script_khmer,
        :script_kannada,
        :script_kaithi,
        :script_tai_tham,
        :script_lao,
        :script_latin,
        :script_lepcha,
        :script_limbu,
        :script_linear_b,
        :script_lisu,
        :script_lycian,
        :script_lydian,
        :script_malayalam,
        :script_mongolian,
        :script_meetei_mayek,
        :script_myanmar,
        :script_nko,
        :script_ogham,
        :script_ol_chiki,
        :script_old_turkic,
        :script_oriya,
        :script_osmanya,
        :script_phags_pa,
        :script_inscriptional_pahlavi,
        :script_phoenician,
        :script_inscriptional_parthian,
        :script_rejang,
        :script_runic,
        :script_samaritan,
        :script_old_south_arabian,
        :script_saurashtra,
        :script_shavian,
        :script_sinhala,
        :script_sundanese,
        :script_syloti_nagri,
        :script_syriac,
        :script_tagbanwa,
        :script_tai_le,
        :script_new_tai_lue,
        :script_tamil,
        :script_tai_viet,
        :script_telugu,
        :script_tifinagh,
        :script_tagalog,
        :script_thaana,
        :script_thai,
        :script_tibetan,
        :script_ugaritic,
        :script_vai,
        :script_old_persian,
        :script_cuneiform,
        :script_yi,
        :script_inherited,
        :script_common,
        :script_unknown
      ]

      Script_V1_9_3 = [:script_brahmi, :script_batak, :script_mandaic]

      Script_V2_2_0 = [
        :script_caucasian_albanian,
        :script_bassa_vah,
        :script_duployan,
        :script_elbasan,
        :script_grantha,
        :script_pahawh_hmong,
        :script_khojki,
        :script_linear_a,
        :script_mahajani,
        :script_manichaean,
        :script_mende_kikakui,
        :script_modi,
        :script_mro,
        :script_old_north_arabian,
        :script_nabataean,
        :script_palmyrene,
        :script_pau_cin_hau,
        :script_old_permic,
        :script_psalter_pahlavi,
        :script_siddham,
        :script_khudawadi,
        :script_tirhuta,
        :script_warang_citi
      ]

      Script = Script_V1_9_0 + Script_V1_9_3 + Script_V2_2_0

      UnicodeBlock = [
        :block_inalphabetic_presentation_forms,
        :block_inarabic_presentation_forms_a,
        :block_inarabic_presentation_forms_b,
        :block_inarabic,
        :block_inarmenian,
        :block_inarrows,
        :block_inbasic_latin,
        :block_inbengali,
        :block_inblock_elements,
        :block_inbopomofo_extended,
        :block_inbopomofo,
        :block_inbox_drawing,
        :block_inbraille_patterns,
        :block_inbuhid,
        :block_incjk_compatibility_forms,
        :block_incjk_compatibility_ideographs,
        :block_incjk_compatibility,
        :block_incjk_radicals_supplement,
        :block_incjk_symbols_and_punctuation,
        :block_incjk_unified_ideographs_extension_a,
        :block_incjk_unified_ideographs,
        :block_incherokee,
        :block_incombining_diacritical_marks_for_symbols,
        :block_incombining_diacritical_marks,
        :block_incombining_half_marks,
        :block_incontrol_pictures,
        :block_incurrency_symbols,
        :block_incyrillic_supplement,
        :block_incyrillic,
        :block_indevanagari,
        :block_indingbats,
        :block_inenclosed_alphanumerics,
        :block_inenclosed_cjk_letters_and_months,
        :block_inethiopic,
        :block_ingeneral_punctuation,
        :block_ingeometric_shapes,
        :block_ingeorgian,
        :block_ingreek_extended,
        :block_ingreek_and_coptic,
        :block_ingujarati,
        :block_ingurmukhi,
        :block_inhalfwidth_and_fullwidth_forms,
        :block_inhangul_compatibility_jamo,
        :block_inhangul_jamo,
        :block_inhangul_syllables,
        :block_inhanunoo,
        :block_inhebrew,
        :block_inhigh_private_use_surrogates,
        :block_inhigh_surrogates,
        :block_inhiragana,
        :block_inipa_extensions,
        :block_inideographic_description_characters,
        :block_inkanbun,
        :block_inkangxi_radicals,
        :block_inkannada,
        :block_inkatakana_phonetic_extensions,
        :block_inkatakana,
        :block_inkhmer_symbols,
        :block_inkhmer,
        :block_inlao,
        :block_inlatin_1_supplement,
        :block_inlatin_extended_a,
        :block_inlatin_extended_b,
        :block_inlatin_extended_additional,
        :block_inletterlike_symbols,
        :block_inlimbu,
        :block_inlow_surrogates,
        :block_inmalayalam,
        :block_inmathematical_operators,
        :block_inmiscellaneous_mathematical_symbols_a,
        :block_inmiscellaneous_mathematical_symbols_b,
        :block_inmiscellaneous_symbols_and_arrows,
        :block_inmiscellaneous_symbols,
        :block_inmiscellaneous_technical,
        :block_inmongolian,
        :block_inmyanmar,
        :block_innumber_forms,
        :block_inogham,
        :block_inoptical_character_recognition,
        :block_inoriya,
        :block_inphonetic_extensions,
        :block_inprivate_use_area,
        :block_inrunic,
        :block_insinhala,
        :block_insmall_form_variants,
        :block_inspacing_modifier_letters,
        :block_inspecials,
        :block_insuperscripts_and_subscripts,
        :block_insupplemental_arrows_a,
        :block_insupplemental_arrows_b,
        :block_insupplemental_mathematical_operators,
        :block_insyriac,
        :block_intagalog,
        :block_intagbanwa,
        :block_intai_le,
        :block_intamil,
        :block_intelugu,
        :block_inthaana,
        :block_inthai,
        :block_intibetan,
        :block_inunified_canadian_aboriginal_syllabics,
        :block_invariation_selectors,
        :block_inyi_radicals,
        :block_inyi_syllables,
        :block_inyijing_hexagram_symbols,
      ]

      Emoji = [
        :emoji_any,
        :emoji_component,
        :emoji_modifier,
        :emoji_modifier_base,
        :emoji_presentation,
      ]

      V1_9_0 = CharType_V1_9_0 + POSIX + Category::All + Derived_V1_9_0 + Script_V1_9_0 + UnicodeBlock
      V1_9_3 = Age_V1_9_3 + Script_V1_9_3

      V2_0_0 = Age_V2_0_0

      V2_2_0 = Age_V2_2_0 + Script_V2_2_0

      V2_3_0 = Age_V2_3_0

      V2_4_0 = Age_V2_4_0

      V2_5_0 = Age_V2_5_0 + CharType_V2_5_0 + Derived_V2_5_0 + Emoji

      All  = V1_9_0 + V1_9_3 + V2_0_0 + V2_2_0 + V2_3_0 + V2_4_0 + V2_5_0

      Type = :property
      NonType = :nonproperty
    end

    Map[UnicodeProperty::Type] = UnicodeProperty::All
    Map[UnicodeProperty::NonType] = UnicodeProperty::All

  end
end
