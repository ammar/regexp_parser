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

  property_sequence     = property_char.'{'.(property_name | general_category).'}';

  action premature_property_end {
    raise "Premature end of pattern (unicode property)"
  }

  # Unicode properties scanner
  # --------------------------------------------------------------------------
  unicode_property := |*
    property_sequence < err(premature_property_end) {
      text = data[ts-1..te-1].pack('c*')

      if in_set
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
      end

      fret;
    };
  *|;
}%%
