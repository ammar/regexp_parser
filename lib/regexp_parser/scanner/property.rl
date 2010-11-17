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

  property_script       = (alpha | space | '_')+; # everything else

  property_sequence     = property_char . '{' . '^'? (
                            property_name | general_category |
                            property_age  | property_derived |
                            property_script
                          ) . '}';

  action premature_property_end {
    raise PrematureEndError.new('unicode property')
  }

  # Unicode properties scanner
  # --------------------------------------------------------------------------
  unicode_property := |*

    property_sequence < eof(premature_property_end) {
      text = data[ts-1..te-1].pack('c*')
      if in_set
        type = :set
      else
        type = text[1,1] == 'p' ? :property : :nonproperty
      end

      name = data[ts+2..te-2].pack('c*').gsub(/[\s_]/,'').downcase
      if name[0].chr == '^'
        name = name[1..-1]
        type = :nonproperty
      end

      case name
      # Named
      when 'alnum'
        self.emit(type, :alnum,       text, ts-1, te)
      when 'alpha'
        self.emit(type, :alpha,       text, ts-1, te)
      when 'ascii'
        self.emit(type, :ascii,       text, ts-1, te)
      when 'blank'
        self.emit(type, :blank,       text, ts-1, te)
      when 'cntrl'
        self.emit(type, :cntrl,       text, ts-1, te)
      when 'digit'
        self.emit(type, :digit,       text, ts-1, te)
      when 'graph'
        self.emit(type, :graph,       text, ts-1, te)
      when 'lower'
        self.emit(type, :lower,       text, ts-1, te)
      when 'print'
        self.emit(type, :print,       text, ts-1, te)
      when 'punct'
        self.emit(type, :punct,       text, ts-1, te)
      when 'space'
        self.emit(type, :space,       text, ts-1, te)
      when 'upper'
        self.emit(type, :upper,       text, ts-1, te)
      when 'xdigit'
        self.emit(type, :xdigit,      text, ts-1, te)

      when 'any'
        self.emit(type, :any,         text, ts-1, te)
      when 'assigned'
        self.emit(type, :assigned,    text, ts-1, te)
      when 'newline'
        self.emit(type, :newline,     text, ts-1, te)
      when 'word'
        self.emit(type, :word,        text, ts-1, te)

      # Letters
      when 'l', 'letter'
        self.emit(type, :letter_any,       text, ts-1, te)
      when 'lu', 'uppercaseletter'
        self.emit(type, :letter_uppercase, text, ts-1, te)
      when 'll', 'lowercaseletter'
        self.emit(type, :letter_lowercase, text, ts-1, te)
      when 'lt', 'titlecaseletter'
        self.emit(type, :letter_titlecase, text, ts-1, te)
      when 'lm', 'modifierletter'
        self.emit(type, :letter_modifier,  text, ts-1, te)
      when 'lo', 'otherletter'
        self.emit(type, :letter_other,     text, ts-1, te)

      # Marks
      when 'm', 'mark'
        self.emit(type, :mark_any,         text, ts-1, te)
      when 'mn', 'nonspacingmark'
        self.emit(type, :mark_nonspacing,  text, ts-1, te)
      when 'mc', 'spacingmark'
        self.emit(type, :mark_spacing,     text, ts-1, te)
      when 'me', 'enclosingmark'
        self.emit(type, :mark_enclosing,   text, ts-1, te)

      # Numbers
      when 'n', 'number'
        self.emit(type, :number_any,       text, ts-1, te)
      when 'nd', 'decimalnumber'
        self.emit(type, :number_decimal,   text, ts-1, te)
      when 'nl', 'letternumber'
        self.emit(type, :number_letter,    text, ts-1, te)
      when 'no', 'othernumber'
        self.emit(type, :number_other,     text, ts-1, te)

      # Punctuation
      when 'p', 'punctuation'
        self.emit(type, :punct_any,        text, ts-1, te)
      when 'pc', 'connectorpunctuation'
        self.emit(type, :punct_connector,  text, ts-1, te)
      when 'pd', 'dashpunctuation'
        self.emit(type, :punct_dash,       text, ts-1, te)
      when 'ps', 'openpunctuation'
        self.emit(type, :punct_open,       text, ts-1, te)
      when 'pe', 'closepunctuation'
        self.emit(type, :punct_close,      text, ts-1, te)
      when 'pi', 'initialpunctuation'
        self.emit(type, :punct_initial,    text, ts-1, te)
      when 'pf', 'finalpunctuation'
        self.emit(type, :punct_final,      text, ts-1, te)
      when 'po', 'otherpunctuation'
        self.emit(type, :punct_other,      text, ts-1, te)

      # Symbols
      when 's', 'symbol'
        self.emit(type, :symbol_any,       text, ts-1, te)
      when 'sm', 'mathsymbol'
        self.emit(type, :symbol_math,      text, ts-1, te)
      when 'sc', 'currencysymbol'
        self.emit(type, :symbol_currency,  text, ts-1, te)
      when 'sk', 'modifiersymbol'
        self.emit(type, :symbol_modifier,  text, ts-1, te)
      when 'so', 'othersymbol'
        self.emit(type, :symbol_other,     text, ts-1, te)

      # Separators
      when 'z', 'separator'
        self.emit(type, :separator_any,    text, ts-1, te)
      when 'zs', 'spaceseparator'
        self.emit(type, :separator_space,  text, ts-1, te)
      when 'zl', 'lineseparator'
        self.emit(type, :separator_line,   text, ts-1, te)
      when 'zp', 'paragraphseparator'
        self.emit(type, :separator_para,   text, ts-1, te)

      # Codepoints
      when 'c', 'other'
        self.emit(type, :other,         text, ts-1, te)
      when 'cc', 'control'
        self.emit(type, :control,       text, ts-1, te)
      when 'cf', 'format'
        self.emit(type, :format,        text, ts-1, te)
      when 'cs', 'surrogate'
        self.emit(type, :surrogate,     text, ts-1, te)
      when 'co', 'privateuse'
        self.emit(type, :private_use,   text, ts-1, te)
      when 'cn', 'unassigned'
        self.emit(type, :unassigned,    text, ts-1, te)

      # Age
      when 'age=1.1'
        self.emit(type, :age_1_1,     text, ts-1, te)
      when 'age=2.0'
        self.emit(type, :age_2_0,     text, ts-1, te)
      when 'age=2.1'
        self.emit(type, :age_2_1,     text, ts-1, te)
      when 'age=3.0'
        self.emit(type, :age_3_0,     text, ts-1, te)
      when 'age=3.1'
        self.emit(type, :age_3_1,     text, ts-1, te)
      when 'age=3.2'
        self.emit(type, :age_3_2,     text, ts-1, te)
      when 'age=4.0'
        self.emit(type, :age_4_0,     text, ts-1, te)
      when 'age=4.1'
        self.emit(type, :age_4_1,     text, ts-1, te)
      when 'age=5.0'
        self.emit(type, :age_5_0,     text, ts-1, te)
      when 'age=5.1'
        self.emit(type, :age_5_1,     text, ts-1, te)
      when 'age=5.2'
        self.emit(type, :age_5_2,     text, ts-1, te)
      when 'age=6.0'
        self.emit(type, :age_6_0,     text, ts-1, te)

      # Derived Properties
      when 'ahex', 'asciihexdigit'
        self.emit(type, :ascii_hex,                       text, ts-1, te)
      when 'alphabetic'
        self.emit(type, :alphabetic,                      text, ts-1, te)
      when 'cased'
        self.emit(type, :cased,                           text, ts-1, te)
      when 'cwcf', 'changeswhencasefolded'
        self.emit(type, :changes_when_casefolded,         text, ts-1, te)
      when 'cwcm', 'changeswhencasemapped'
        self.emit(type, :changes_when_casemapped,         text, ts-1, te)
      when 'cwl', 'changeswhenlowercased'
        self.emit(type, :changes_when_lowercased,         text, ts-1, te)
      when 'cwt', 'changeswhentitlecased'
        self.emit(type, :changes_when_titlecased,         text, ts-1, te)
      when 'cwu', 'changeswhenuppercased'
        self.emit(type, :changes_when_uppercased,         text, ts-1, te)
      when 'ci', 'caseignorable'
        self.emit(type, :case_ignorable,                  text, ts-1, te)
      when 'bidic', 'bidicontrol'
        self.emit(type, :bidi_control,                    text, ts-1, te)
      when 'dash'
        self.emit(type, :dash,                            text, ts-1, te)
      when 'dep', 'deprecated'
        self.emit(type, :deprecated,                      text, ts-1, te)
      when 'di', 'defaultignorablecodepoint'
        self.emit(type, :default_ignorable_cp,            text, ts-1, te)
      when 'dia', 'diacritic'
        self.emit(type, :diacritic,                       text, ts-1, te)
      when 'ext', 'extender'
        self.emit(type, :extender,                        text, ts-1, te)
      when 'grbase', 'graphemebase'
        self.emit(type, :grapheme_base,                   text, ts-1, te)
      when 'grext', 'graphemeextend'
        self.emit(type, :grapheme_extend,                 text, ts-1, te)
      when 'grlink', 'graphemelink' # NOTE: deprecated as of Unicode 5.0
        self.emit(type, :grapheme_link,                   text, ts-1, te)
      when 'hex', 'hexdigit'
        self.emit(type, :hex_digit,                       text, ts-1, te)
      when 'hyphen' # NOTE: deprecated as of Unicode 6.0
        self.emit(type, :hyphen,                          text, ts-1, te)
      when 'idc', 'idcontinue'
        self.emit(type, :id_continue,                     text, ts-1, te)
      when 'ideo', 'ideographic'
        self.emit(type, :ideographic,                     text, ts-1, te)
      when 'ids', 'idstart'
        self.emit(type, :id_start,                        text, ts-1, te)
      when 'idsb', 'idsbinaryoperator'
        self.emit(type, :ids_binary_op,                   text, ts-1, te)
      when 'idst', 'idstrinaryoperator'
        self.emit(type, :ids_trinary_op,                  text, ts-1, te)
      when 'joinc', 'joincontrol'
        self.emit(type, :join_control,                    text, ts-1, te)
      when 'loe', 'logicalorderexception'
        self.emit(type, :logical_order_exception,         text, ts-1, te)
      when 'lowercase'
        self.emit(type, :lowercase,                       text, ts-1, te)
      when 'math'
        self.emit(type, :math,                            text, ts-1, te)
      when 'nchar', 'noncharactercodepoint'
        self.emit(type, :non_character_cp,                text, ts-1, te)
      when 'oalpha', 'otheralphabetic'
        self.emit(type, :other_alphabetic,                text, ts-1, te)
      when 'odi', 'otherdefaultignorablecodepoint'
        self.emit(type, :other_default_ignorable_cp,      text, ts-1, te)
      when 'ogrext', 'othergraphemeextend'
        self.emit(type, :other_grapheme_extended,         text, ts-1, te)
      when 'oidc', 'otheridcontinue'
        self.emit(type, :other_id_continue,               text, ts-1, te)
      when 'oids', 'otheridstart'
        self.emit(type, :other_id_start,                  text, ts-1, te)
      when 'olower', 'otherlowercase'
        self.emit(type, :other_lowercase,                 text, ts-1, te)
      when 'omath', 'othermath'
        self.emit(type, :other_math,                      text, ts-1, te)
      when 'oupper', 'otheruppercase'
        self.emit(type, :other_uppercase,                 text, ts-1, te)
      when 'patsyn', 'patternsyntax'
        self.emit(type, :pattern_syntax,                  text, ts-1, te)
      when 'patws', 'patternwhitespace'
        self.emit(type, :pattern_whitespace,              text, ts-1, te)
      when 'qmark', 'quotationmark'
        self.emit(type, :quotation_mark,                  text, ts-1, te)
      when 'radical'
        self.emit(type, :radical,                         text, ts-1, te)
      when 'sd', 'softdotted'
        self.emit(type, :soft_dotted,                     text, ts-1, te)
      when 'sterm'
        self.emit(type, :sentence_terminal,               text, ts-1, te)
      when 'term', 'terminalpunctuation'
        self.emit(type, :terminal_punctuation,            text, ts-1, te)
      when 'uideo', 'unifiedideograph'
        self.emit(type, :unified_ideograph,               text, ts-1, te)
      when 'uppercase'
        self.emit(type, :uppercase,                       text, ts-1, te)
      when 'vs', 'variationselector'
        self.emit(type, :variation_selector,              text, ts-1, te)
      when 'wspace', 'whitespace'
        self.emit(type, :whitespace,                      text, ts-1, te)
      when 'xids', 'xidstart'
        self.emit(type, :xid_start,                       text, ts-1, te)
      when 'xidc', 'xidcontinue'
        self.emit(type, :xid_continue,                    text, ts-1, te)


      # Scripts
      when 'arab', 'arabic'
        self.emit(type, :script_arabic,                   text, ts-1, te)
      when 'armi', 'imperialaramaic'
        self.emit(type, :script_imperial_aramaic,         text, ts-1, te)
      when 'armn', 'armenian'
        self.emit(type, :script_armenian,                 text, ts-1, te)
      when 'avst', 'avestan'
        self.emit(type, :script_avestan,                  text, ts-1, te)
      when 'bali', 'balinese'
        self.emit(type, :script_balinese,                 text, ts-1, te)
      when 'bamu', 'bamum'
        self.emit(type, :script_bamum,                    text, ts-1, te)
      when 'batk', 'batak'
        self.emit(type, :script_batak,                    text, ts-1, te)
      when 'beng', 'bengali'
        self.emit(type, :script_bengali,                  text, ts-1, te)
      when 'bopo', 'bopomofo'
        self.emit(type, :script_bopomofo,                 text, ts-1, te)
      when 'brah', 'brahmi'
        self.emit(type, :script_brahmi,                   text, ts-1, te)
      when 'brai', 'braille'
        self.emit(type, :script_braille,                  text, ts-1, te)
      when 'bugi', 'buginese'
        self.emit(type, :script_buginese,                 text, ts-1, te)
      when 'buhd', 'buhid'
        self.emit(type, :script_buhid,                    text, ts-1, te)
      when 'cans', 'canadianaboriginal'
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
      when 'egyp', 'egyptianhieroglyphs'
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
      when 'hrkt', 'katakanaorhiragana'
        self.emit(type, :script_katakana_or_hiragana,     text, ts-1, te)
      when 'ital', 'olditalic'
        self.emit(type, :script_old_italic,               text, ts-1, te)
      when 'java', 'javanese'
        self.emit(type, :script_javanese,                 text, ts-1, te)
      when 'kali', 'kayahli'
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
      when 'lana', 'taitham'
        self.emit(type, :script_tai_tham,                 text, ts-1, te)
      when 'laoo', 'lao'
        self.emit(type, :script_lao,                      text, ts-1, te)
      when 'latn', 'latin'
        self.emit(type, :script_latin,                    text, ts-1, te)
      when 'lepc', 'lepcha'
        self.emit(type, :script_lepcha,                   text, ts-1, te)
      when 'limb', 'limbu'
        self.emit(type, :script_limbu,                    text, ts-1, te)
      when 'linb', 'linearb'
        self.emit(type, :script_linear_b,                 text, ts-1, te)
      when 'lisu'
        self.emit(type, :script_lisu,                     text, ts-1, te)
      when 'lyci', 'lycian'
        self.emit(type, :script_lycian,                   text, ts-1, te)
      when 'lydi', 'lydian'
        self.emit(type, :script_lydian,                   text, ts-1, te)
      when 'mlym', 'malayalam'
        self.emit(type, :script_malayalam,                text, ts-1, te)
      when 'mand', 'mandaic'
        self.emit(type, :script_mandaic,                  text, ts-1, te)
      when 'mong', 'mongolian'
        self.emit(type, :script_mongolian,                text, ts-1, te)
      when 'mtei', 'meeteimayek'
        self.emit(type, :script_meetei_mayek,             text, ts-1, te)
      when 'mymr', 'myanmar'
        self.emit(type, :script_myanmar,                  text, ts-1, te)
      when 'nkoo', 'nko'
        self.emit(type, :script_nko,                      text, ts-1, te)
      when 'ogam', 'ogham'
        self.emit(type, :script_ogham,                    text, ts-1, te)
      when 'olck', 'olchiki'
        self.emit(type, :script_ol_chiki,                 text, ts-1, te)
      when 'orkh', 'oldturkic'
        self.emit(type, :script_old_turkic,               text, ts-1, te)
      when 'orya', 'oriya'
        self.emit(type, :script_oriya,                    text, ts-1, te)
      when 'osma', 'osmanya'
        self.emit(type, :script_osmanya,                  text, ts-1, te)
      when 'phag', 'phagspa'
        self.emit(type, :script_phags_pa,                 text, ts-1, te)
      when 'phli', 'inscriptionalpahlavi'
        self.emit(type, :script_inscriptional_pahlavi,    text, ts-1, te)
      when 'phnx', 'phoenician'
        self.emit(type, :script_phoenician,               text, ts-1, te)
      when 'prti', 'inscriptionalparthian'
        self.emit(type, :script_inscriptional_parthian,   text, ts-1, te)
      when 'rjng', 'rejang'
        self.emit(type, :script_rejang,                   text, ts-1, te)
      when 'runr', 'runic'
        self.emit(type, :script_runic,                    text, ts-1, te)
      when 'samr', 'samaritan'
        self.emit(type, :script_samaritan,                text, ts-1, te)
      when 'sarb', 'oldsoutharabian'
        self.emit(type, :script_old_south_arabian,        text, ts-1, te)
      when 'saur', 'saurashtra'
        self.emit(type, :script_saurashtra,               text, ts-1, te)
      when 'shaw', 'shavian'
        self.emit(type, :script_shavian,                  text, ts-1, te)
      when 'sinh', 'sinhala'
        self.emit(type, :script_sinhala,                  text, ts-1, te)
      when 'sund', 'sundanese'
        self.emit(type, :script_sundanese,                text, ts-1, te)
      when 'sylo', 'sylotinagri'
        self.emit(type, :script_syloti_nagri,             text, ts-1, te)
      when 'syrc', 'syriac'
        self.emit(type, :script_syriac,                   text, ts-1, te)
      when 'tagb', 'tagbanwa'
        self.emit(type, :script_tagbanwa,                 text, ts-1, te)
      when 'tale', 'taile'
        self.emit(type, :script_tai_le,                   text, ts-1, te)
      when 'talu', 'newtailue'
        self.emit(type, :script_new_tai_lue,              text, ts-1, te)
      when 'taml', 'tamil'
        self.emit(type, :script_tamil,                    text, ts-1, te)
      when 'tavt', 'taiviet'
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
      when 'xpeo', 'oldpersian'
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
        raise UnknownUnicodePropertyError.new(name)

      end
      fret;
    };
  *|;
}%%
