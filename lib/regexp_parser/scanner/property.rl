%%{
  machine re_property;

  property_char         = [pP];

  # Property names are being treated as case-insensitive, but it is not clear
  # yet if this applies to all flavors and in all encodings. A bug has just
  # been filed against ruby regarding this issue, see:
  #   http://redmine.ruby-lang.org/issues/show/4014
  property_name_unicode = 'alnum'i | 'alpha'i | 'any'i   | 'ascii'i | 'blank'i |
                          'cntrl'i | 'digit'i | 'graph'i | 'lower'i | 'print'i |
                          'punct'i | 'space'i | 'upper'i | 'word'i  | 'xdigit'i;

  # TODO: are these case-insensitive?
  property_name_posix   = 'any'i | 'assigned'i | 'newline'i;

  property_name         = property_name_unicode | property_name_posix;

  category_letter       = [Ll] . [ultmo]?;
  category_mark         = [Mm] . [nce]?;
  category_number       = [Nn] . [dlo]?;
  category_punctuation  = [Pp] . [cdseifo]?;
  category_symbol       = [Ss] . [mcko]?;
  category_separator    = [Zz] . [slp]?;
  category_codepoint    = [Cc] . [cfson]?;

  general_category      = category_letter | category_mark |
                          category_number | category_punctuation |
                          category_symbol | category_separator |
                          category_codepoint;

  property_derived      = 'math'i           | 'alphabetic'i       |
                          'lowercase'i      | 'uppercase'i        |
                          'id_start'i       | 'id_continue'i      |
                          'xid_start'i      | 'xid_continue'i     |
                          'grapheme_base'i  | 'grapheme_extend'i  |
                          'default_ignorable_code_point'i; 

  property_age          = 'age=1.1'i | 'age=2.0'i | 'age=2.1'i |
                          'age=3.0'i | 'age=3.1'i | 'age=3.2'i |
                          'age=4.0'i | 'age=4.1'i | 'age=5.0'i |
                          'age=5.1'i | 'age=5.2'i | 'age=6.0'i;

  property_script       = (alpha | space)+; # a bit too permissive

  property_sequence     = property_char.'{'.(
                            property_name | general_category |
                            property_age  | property_derived |
                            property_script
                          ).'}';

  action premature_property_end {
    raise "Premature end of pattern (unicode property)"
  }

  # Unicode properties scanner
  # --------------------------------------------------------------------------
  unicode_property := |*

    # TODO: break this into smaller states.
    property_sequence < eof(premature_property_end) {
      text = data[ts-1..te-1].pack('c*')

      if in_set # TODO: sets can have sub-sets, a boolean is not enough!
        type = :set
        pref = text[1,1] == 'p' ? :property : :nonproperty
      else
        type = text[1,1] == 'p' ? :property : :nonproperty
        pref = ''
      end
      # TODO: add ^ for property negation, :nonproperty_caret

      case name = data[ts+2..te-2].pack('c*').downcase

      # Named
      when 'alnum';   self.emit(type, :alnum,       text, ts-1, te)
      when 'alpha';   self.emit(type, :alpha,       text, ts-1, te)
      when 'any';     self.emit(type, :any,         text, ts-1, te)
      when 'ascii';   self.emit(type, :ascii,       text, ts-1, te)
      when 'blank';   self.emit(type, :blank,       text, ts-1, te)
      when 'cntrl';   self.emit(type, :cntrl,       text, ts-1, te)
      when 'digit';   self.emit(type, :digit,       text, ts-1, te)
      when 'graph';   self.emit(type, :graph,       text, ts-1, te)
      when 'lower';   self.emit(type, :lower,       text, ts-1, te)
      when 'newline'; self.emit(type, :newline,     text, ts-1, te)
      when 'print';   self.emit(type, :print,       text, ts-1, te)
      when 'punct';   self.emit(type, :punct,       text, ts-1, te)
      when 'space';   self.emit(type, :space,       text, ts-1, te)
      when 'upper';   self.emit(type, :upper,       text, ts-1, te)
      when 'word';    self.emit(type, :word,        text, ts-1, te)
      when 'xdigit';  self.emit(type, :xdigit,      text, ts-1, te)

      # Letters
      when 'l';  self.emit(type, :letter_any,       text, ts-1, te)
      when 'lu'; self.emit(type, :letter_uppercase, text, ts-1, te)
      when 'll'; self.emit(type, :letter_lowercase, text, ts-1, te)
      when 'lt'; self.emit(type, :letter_titlecase, text, ts-1, te)
      when 'lm'; self.emit(type, :letter_modifier,  text, ts-1, te)
      when 'lo'; self.emit(type, :letter_other,     text, ts-1, te)

      # Marks
      when 'm';  self.emit(type, :mark_any,         text, ts-1, te)
      when 'mn'; self.emit(type, :mark_nonspacing,  text, ts-1, te)
      when 'mc'; self.emit(type, :mark_spacing,     text, ts-1, te)
      when 'me'; self.emit(type, :mark_enclosing,   text, ts-1, te)

      # Numbers
      when 'n';  self.emit(type, :number_any,       text, ts-1, te)
      when 'nd'; self.emit(type, :number_decimal,   text, ts-1, te)
      when 'nl'; self.emit(type, :number_letter,    text, ts-1, te)
      when 'no'; self.emit(type, :number_other,     text, ts-1, te)

      # Punctuation
      when 'p';  self.emit(type, :punct_any,        text, ts-1, te)
      when 'pc'; self.emit(type, :punct_connector,  text, ts-1, te)
      when 'pd'; self.emit(type, :punct_dash,       text, ts-1, te)
      when 'ps'; self.emit(type, :punct_open,       text, ts-1, te)
      when 'pe'; self.emit(type, :punct_close,      text, ts-1, te)
      when 'pi'; self.emit(type, :punct_initial,    text, ts-1, te)
      when 'pf'; self.emit(type, :punct_final,      text, ts-1, te)
      when 'po'; self.emit(type, :punct_other,      text, ts-1, te)

      # Symbols
      when 's';  self.emit(type, :symbol_any,       text, ts-1, te)
      when 'sm'; self.emit(type, :symbol_math,      text, ts-1, te)
      when 'sc'; self.emit(type, :symbol_currency,  text, ts-1, te)
      when 'sk'; self.emit(type, :symbol_modifier,  text, ts-1, te)
      when 'so'; self.emit(type, :symbol_other,     text, ts-1, te)

      # Separators
      when 'z';  self.emit(type, :separator_any,    text, ts-1, te)
      when 'zs'; self.emit(type, :separator_space,  text, ts-1, te)
      when 'zl'; self.emit(type, :separator_line,   text, ts-1, te)
      when 'zp'; self.emit(type, :separator_para,   text, ts-1, te)

      # Codepoints
      when 'c';  self.emit(type, :cp_any,           text, ts-1, te)
      when 'cc'; self.emit(type, :cp_control,       text, ts-1, te)
      when 'cf'; self.emit(type, :cp_format,        text, ts-1, te)
      when 'cs'; self.emit(type, :cp_surrogate,     text, ts-1, te)
      when 'co'; self.emit(type, :cp_private,       text, ts-1, te)
      when 'cn'; self.emit(type, :cp_unassigned,    text, ts-1, te)

      # Age
      when 'age=1.1'; self.emit(type, :age_1_1,     text, ts-1, te)
      when 'age=2.0'; self.emit(type, :age_2_0,     text, ts-1, te)
      when 'age=2.1'; self.emit(type, :age_2_1,     text, ts-1, te)
      when 'age=3.0'; self.emit(type, :age_3_0,     text, ts-1, te)
      when 'age=3.1'; self.emit(type, :age_3_1,     text, ts-1, te)
      when 'age=3.2'; self.emit(type, :age_3_2,     text, ts-1, te)
      when 'age=4.0'; self.emit(type, :age_4_0,     text, ts-1, te)
      when 'age=4.1'; self.emit(type, :age_4_1,     text, ts-1, te)
      when 'age=5.0'; self.emit(type, :age_5_0,     text, ts-1, te)
      when 'age=5.1'; self.emit(type, :age_5_1,     text, ts-1, te)
      when 'age=5.2'; self.emit(type, :age_5_2,     text, ts-1, te)
      when 'age=6.0'; self.emit(type, :age_6_0,     text, ts-1, te)

      # Derived: Core
      when 'math'
        self.emit(type, :derived_math,                  text, ts-1, te)
      when 'alphabetic'
        self.emit(type, :derived_alphabetic,            text, ts-1, te)
      when 'lowercase'
        self.emit(type, :derived_lowercase,             text, ts-1, te)
      when 'uppercase'
        self.emit(type, :derived_uppercase,             text, ts-1, te)
      when 'id_start'
        self.emit(type, :derived_id_start,              text, ts-1, te)
      when 'id_continue'
        self.emit(type, :derived_id_continue,           text, ts-1, te)
      when 'xid_start'
        self.emit(type, :derived_xid_start,             text, ts-1, te)
      when 'xid_continue'
        self.emit(type, :derived_xid_continue,          text, ts-1, te)
      when 'default_ignorable_code_point'
        self.emit(type, :derived_default_ignorable_cp,  text, ts-1, te)
      when 'grapheme_base'
        self.emit(type, :derived_grapheme_base,         text, ts-1, te)
      when 'grapheme_extend'
        self.emit(type, :derived_grapheme_extend,       text, ts-1, te)

      # Scripts
      when 'arab', 'arabic'
        self.emit(type, :script_arabic,                   text, ts-1, te)
      when 'armi', 'imperial aramaic'
        self.emit(type, :script_imperial_aramaic,         text, ts-1, te)
      when 'armn', 'armenian'
        self.emit(type, :script_armenian,                 text, ts-1, te)
      when 'avst', 'avestan'
        self.emit(type, :script_avestan,                  text, ts-1, te)
      when 'bali', 'balinese'
        self.emit(type, :script_balinese,                 text, ts-1, te)
      when 'bamu', 'bamum'
        self.emit(type, :script_bamum,                    text, ts-1, te)
      when 'beng', 'bengali'
        self.emit(type, :script_bengali,                  text, ts-1, te)
      when 'bopo', 'bopomofo'
        self.emit(type, :script_bopomofo,                 text, ts-1, te)
      when 'brai', 'braille'
        self.emit(type, :script_braille,                  text, ts-1, te)
      when 'bugi', 'buginese'
        self.emit(type, :script_buginese,                 text, ts-1, te)
      when 'buhd', 'buhid'
        self.emit(type, :script_buhid,                    text, ts-1, te)
      when 'cans', 'canadian aboriginal'
        self.emit(type, :script_canadian_aboriginal,      text, ts-1, te)
      when 'cari', 'carian'
        self.emit(type, :script_carian,                   text, ts-1, te)
      when 'cham'
        self.emit(type, :script_cham,                     text, ts-1, te)
      when 'cher', 'cherokee'
        self.emit(type, :script_cherokee,                 text, ts-1, te)
      when 'copt', 'coptic', 'qaac'
        self.emit(type, :script_coptic,                   text, ts-1, te)
      when 'cprt', 'cypriot'
        self.emit(type, :script_cypriot,                  text, ts-1, te)
      when 'cyrl', 'cyrillic'
        self.emit(type, :script_cyrillic,                 text, ts-1, te)
      when 'deva', 'devanagari'
        self.emit(type, :script_devanagari,               text, ts-1, te)
      when 'dsrt', 'deseret'
        self.emit(type, :script_deseret,                  text, ts-1, te)
      when 'egyp', 'egyptian hieroglyphs'
        self.emit(type, :script_egyptian_hieroglyphs,     text, ts-1, te)
      when 'ethi', 'ethiopic'
        self.emit(type, :script_ethiopic,                 text, ts-1, te)
      when 'geor', 'georgian'
        self.emit(type, :script_georgian,                 text, ts-1, te)
      when 'glag', 'glagolitic'
        self.emit(type, :script_glagolitic,               text, ts-1, te)
      when 'goth', 'gothic'
        self.emit(type, :script_gothic,                   text, ts-1, te)
      when 'grek', 'greek'
        self.emit(type, :script_greek,                    text, ts-1, te)
      when 'gujr', 'gujarati'
        self.emit(type, :script_gujarati,                 text, ts-1, te)
      when 'guru', 'gurmukhi'
        self.emit(type, :script_gurmukhi,                 text, ts-1, te)
      when 'hang', 'hangul'
        self.emit(type, :script_hangul,                   text, ts-1, te)
      when 'hani', 'han'
        self.emit(type, :script_han,                      text, ts-1, te)
      when 'hano', 'hanunoo'
        self.emit(type, :script_hanunoo,                  text, ts-1, te)
      when 'hebr', 'hebrew'
        self.emit(type, :script_hebrew,                   text, ts-1, te)
      when 'hira', 'hiragana'
        self.emit(type, :script_hiragana,                 text, ts-1, te)
      when 'hrkt', 'katakana or hiragana'
        self.emit(type, :script_katakana_or_hiragana,     text, ts-1, te)
      when 'ital', 'old italic'
        self.emit(type, :script_old_italic,               text, ts-1, te)
      when 'java', 'javanese'
        self.emit(type, :script_javanese,                 text, ts-1, te)
      when 'kali', 'kayah li'
        self.emit(type, :script_kayah_li,                 text, ts-1, te)
      when 'kana', 'katakana'
        self.emit(type, :script_katakana,                 text, ts-1, te)
      when 'khar', 'kharoshthi'
        self.emit(type, :script_kharoshthi,               text, ts-1, te)
      when 'khmr', 'khmer'
        self.emit(type, :script_khmer,                    text, ts-1, te)
      when 'knda', 'kannada'
        self.emit(type, :script_kannada,                  text, ts-1, te)
      when 'kthi', 'kaithi'
        self.emit(type, :script_kaithi,                   text, ts-1, te)
      when 'lana', 'tai tham'
        self.emit(type, :script_tai_tham,                 text, ts-1, te)
      when 'laoo', 'lao'
        self.emit(type, :script_lao,                      text, ts-1, te)
      when 'latn', 'latin'
        self.emit(type, :script_latin,                    text, ts-1, te)
      when 'lepc', 'lepcha'
        self.emit(type, :script_lepcha,                   text, ts-1, te)
      when 'limb', 'limbu'
        self.emit(type, :script_limbu,                    text, ts-1, te)
      when 'linb', 'linear b'
        self.emit(type, :script_linear_b,                 text, ts-1, te)
      when 'lisu'
        self.emit(type, :script_lisu,                     text, ts-1, te)
      when 'lyci', 'lycian'
        self.emit(type, :script_lycian,                   text, ts-1, te)
      when 'lydi', 'lydian'
        self.emit(type, :script_lydian,                   text, ts-1, te)
      when 'mlym', 'malayalam'
        self.emit(type, :script_malayalam,                text, ts-1, te)
      when 'mong', 'mongolian'
        self.emit(type, :script_mongolian,                text, ts-1, te)
      when 'mtei', 'meetei mayek'
        self.emit(type, :script_meetei_mayek,             text, ts-1, te)
      when 'mymr', 'myanmar'
        self.emit(type, :script_myanmar,                  text, ts-1, te)
      when 'nkoo', 'nko'
        self.emit(type, :script_nko,                      text, ts-1, te)
      when 'ogam', 'ogham'
        self.emit(type, :script_ogham,                    text, ts-1, te)
      when 'olck', 'ol chiki'
        self.emit(type, :script_ol_chiki,                 text, ts-1, te)
      when 'orkh', 'old turkic'
        self.emit(type, :script_old_turkic,               text, ts-1, te)
      when 'orya', 'oriya'
        self.emit(type, :script_oriya,                    text, ts-1, te)
      when 'osma', 'osmanya'
        self.emit(type, :script_osmanya,                  text, ts-1, te)
      when 'phag', 'phags pa'
        self.emit(type, :script_phags_pa,                 text, ts-1, te)
      when 'phli', 'inscriptional pahlavi'
        self.emit(type, :script_inscriptional_pahlavi,    text, ts-1, te)
      when 'phnx', 'phoenician'
        self.emit(type, :script_phoenician,               text, ts-1, te)
      when 'prti', 'inscriptional parthian'
        self.emit(type, :script_inscriptional_parthian,   text, ts-1, te)
      when 'rjng', 'rejang'
        self.emit(type, :script_rejang,                   text, ts-1, te)
      when 'runr', 'runic'
        self.emit(type, :script_runic,                    text, ts-1, te)
      when 'samr', 'samaritan'
        self.emit(type, :script_samaritan,                text, ts-1, te)
      when 'sarb', 'old south arabian'
        self.emit(type, :script_old_south_arabian,        text, ts-1, te)
      when 'saur', 'saurashtra'
        self.emit(type, :script_saurashtra,               text, ts-1, te)
      when 'shaw', 'shavian'
        self.emit(type, :script_shavian,                  text, ts-1, te)
      when 'sinh', 'sinhala'
        self.emit(type, :script_sinhala,                  text, ts-1, te)
      when 'sund', 'sundanese'
        self.emit(type, :script_sundanese,                text, ts-1, te)
      when 'sylo', 'syloti nagri'
        self.emit(type, :script_syloti_nagri,             text, ts-1, te)
      when 'syrc', 'syriac'
        self.emit(type, :script_syriac,                   text, ts-1, te)
      when 'tagb', 'tagbanwa'
        self.emit(type, :script_tagbanwa,                 text, ts-1, te)
      when 'tale', 'tai le'
        self.emit(type, :script_tai_le,                   text, ts-1, te)
      when 'talu', 'new tai lue'
        self.emit(type, :script_new_tai_lue,              text, ts-1, te)
      when 'taml', 'tamil'
        self.emit(type, :script_tamil,                    text, ts-1, te)
      when 'tavt', 'tai viet'
        self.emit(type, :script_tai_viet,                 text, ts-1, te)
      when 'telu', 'telugu'
        self.emit(type, :script_telugu,                   text, ts-1, te)
      when 'tfng', 'tifinagh'
        self.emit(type, :script_tifinagh,                 text, ts-1, te)
      when 'tglg', 'tagalog'
        self.emit(type, :script_tagalog,                  text, ts-1, te)
      when 'thaa', 'thaana'
        self.emit(type, :script_thaana,                   text, ts-1, te)
      when 'thai' 
        self.emit(type, :script_thai,                     text, ts-1, te)
      when 'tibt', 'tibetan'
        self.emit(type, :script_tibetan,                  text, ts-1, te)
      when 'ugar', 'ugaritic'
        self.emit(type, :script_ugaritic,                 text, ts-1, te)
      when 'vaii', 'vai'
        self.emit(type, :script_vai,                      text, ts-1, te)
      when 'xpeo', 'old persian'
        self.emit(type, :script_old_persian,              text, ts-1, te)
      when 'xsux', 'cuneiform'
        self.emit(type, :script_cuneiform,                text, ts-1, te)
      when 'yiii', 'yi'
        self.emit(type, :script_yi,                       text, ts-1, te)
      when 'zinh', 'inherited', 'qaai'
        self.emit(type, :script_inherited,                text, ts-1, te)
      when 'zyyy', 'common'
        self.emit(type, :script_common,                   text, ts-1, te)
      when 'zzzz', 'unknown'
        self.emit(type, :script_unknown,                  text, ts-1, te)

      else
        raise "Unknown unicode character property name #{name}"

      end
      fret;
    };
  *|;
}%%
