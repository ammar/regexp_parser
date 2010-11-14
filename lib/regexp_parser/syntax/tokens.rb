module Regexp::Syntax

  module Token
    module Meta
      Basic     = [:dot]
      Extended  = Basic + [:alternation]
    end

    module Anchor
      Basic     = [:beginning_of_line, :end_of_line]
      Extended  = Basic + [:word_boundary, :nonword_boundary]
      String    = [:bos, :eos, :eos_ob_eol]
    end

    module Group
      Basic     = [:capture, :close]
      Extended  = Basic + [:options]

      Named     = [:named]
      Atomic    = [:atomic]
      Passive   = [:passive]
      Comment   = [:comment]

      module Assertion
        Positive = [:lookahead, :lookbehind]
        Negative = [:nlookahead, :nlookbehind]

        All = Positive + Negative
      end

      All = Group::Extended + Group::Named + Group::Atomic +
            Group::Passive + Group::Comment
    end


    module CharacterType
      Basic     = []
      Extended  = [:digit, :nondigit, :space, :nonspace, :word, :nonword]
      Hex       = [:hex, :nonhex]

      All = Basic + Extended + Hex
    end

    module CharacterSet
      OpenClose = [:open, :close]

      Basic     = [:negate, :member, :range]
      Extended  = Basic + [:escape, :intersection, :range_hex, :backspace]

      Types     = [:type_digit, :type_nondigit, :type_hex, :type_nonhex,
                   :type_space, :type_nonspace, :type_word, :type_nonword]

      module POSIX
        Standard  = [:class_alnum, :class_alpha, :class_blank, :class_cntrl,
                     :class_digit, :class_graph, :class_lower, :class_print,
                     :class_punct, :class_space, :class_upper, :class_xdigit]

        Extensions = [:class_ascii, :class_word]
        All         = Standard + Extensions
      end

      All = Basic + Extended + Types + POSIX::All
    end

    module Quantifier
      Greedy      = [:zero_or_one, :zero_or_more, :one_or_more]
      Reluctant   = [:zero_or_one_reluctant, :zero_or_more_reluctant, :one_or_more_reluctant]
      Possessive  = [:zero_or_one_possessive, :zero_or_more_possessive, :one_or_more_possessive]
      Interval    = [:interval]
    end

    module Escape
      Basic     = [:backslash, :literal]

      Backreference = [:digit]

      ASCII = [:bell, :backspace, :escape, :form_feed, :newline, :carriage,
               :space, :tab, :vertical_tab]

      Meta  = [:dot, :alternation, :zero_or_one, :zero_or_more, :one_or_more,
               :beginning_of_line, :end_of_line, :group_open, :group_close,
               :interval_open, :interval_close, :set_open, :set_close, :baclslash]

      All   = Basic + Backreference + ASCII + Meta
    end

    module CharacterProperty
      Type    = [:alnum, :alpha, :ascii, :blank, :cntrl, :digit, :graph, :lower,
                 :print, :punct, :space, :upper, :word, :xdigit]

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

      Age = [:age_1_1, :age_2_0, :age_2_1, :age_3_0, :age_3_1,
             :age_3_2, :age_4_0, :age_4_1, :age_5_0, :age_5_1,
             :age_5_2, :age_6_0]

      Derived = [
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

      Script =[
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

      All = Type + POSIX + Category::All + Age + Derived + Script
    end
  end

end
