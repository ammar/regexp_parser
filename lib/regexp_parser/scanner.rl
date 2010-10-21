%%{
  machine re_scanner;

  wild                  = '.';
  backslash             = '\\';
  alternation           = '|';
  beginning_of_line     = '^';
  end_of_line           = '$';

  range_open            = '{';
  range_close           = '}';
  curlies               = range_open | range_close;

  group_open            = '(';
  group_close           = ')';
  parantheses           = group_open | group_close;

  set_open              = '[';
  set_close             = ']';
  brackets              = set_open | set_close;

  posix_class_name      = 'alnum' | 'alpha' | 'blank' |
                          'cntrl' | 'digit' | 'graph' |
                          'lower' | 'print' | 'punct' |
                          'space' | 'upper' | 'xdigit' |
                          'word'  | 'ascii';

  property_name         = 'Alnum' | 'Alpha' | 'Any'   | 'Ascii' | 'Blank' |
                          'Cntrl' | 'Digit' | 'Graph' | 'Lower' | 'Print' |
                          'Punct' | 'Space' | 'Upper' | 'Word' | 'Xdigit';

  category_letter       = 'L' . [ultmo]?;
  category_mark         = 'M' . [nce]?;
  category_number       = 'N' . [dlo]?;
  category_punctuation  = 'P' . [cdseifo]?;
  category_symbol       = 'S' . [mcko]?;
  category_separator    = 'Z' . [slp]?;
  category_codepoint    = 'C' . [cfson]?;
  general_category      = category_letter | category_mark |
                          category_number | category_punctuation |
                          category_symbol | category_separator |
                          category_codepoint;

  posix_class           = '[:' . posix_class_name . ':]';

  char_type             = [dDhHsSwW];

  line_anchor           = beginning_of_line | end_of_line;
  anchor_char           = [AbBzZG];
  property_char         = [pP];

  escaped_char          = [aefnrtv];
  octal_sequence        = '0' . [0-7]{2};

  hex_sequence          = 'x' . xdigit{2};
  wide_hex_sequence     = 'x' . '{7' . xdigit{1,7} . '}';
  control_sequence      = ('c' | 'C-') . xdigit{1,2};
  meta_sequence         = 'M-' . xdigit{1,2};
  meta_control_sequence = 'M-\\C-' . xdigit{1,2};

  zero_or_one           = '?' | '??' | '?+';
  zero_or_more          = '*' | '*?' | '*+';
  one_or_more           = '+' | '+?' | '++';

  quantifier_greedy     = '?'  | '*'  | '+';
  quantifier_reluctant  = '??' | '*?' | '+?';
  quantifier_possessive = '?+' | '*+' | '++';
  quantifier_mode       = '?'  | '+';

  quantifier_range      = range_open . (digit+)? . ','? . (digit+)? .
                          range_close . quantifier_mode?;

  quantifiers           = quantifier_greedy | quantifier_reluctant |
                          quantifier_possessive | quantifier_range;


  group_comment         = '?#' . [^)]+ . group_close;

  group_atomic          = '?>';
  group_passive         = '?:';

  assertion_lookahead   = '?=';
  assertion_nlookahead  = '?!';
  assertion_lookbehind  = '?<=';
  assertion_nlookbehind = '?<!';

  group_options         = '?' . ([mix]{1,3})? . '-' . ([mix]{1,3})? . ':'?;

  group_name            = alpha . alnum+;
  group_named           = '?<' . group_name . '>';

  group_type            = group_atomic | group_passive | group_named;

  assertion_type        = assertion_lookahead  | assertion_nlookahead |
                          assertion_lookbehind | assertion_nlookbehind;

  # characters the 'break' a literal
  meta_char             = wild | backslash | alternation |
                          curlies | parantheses | brackets |
                          line_anchor | quantifier_greedy;


  # Character set scanner, continues consuming characters until it meets the
  # closing bracket of the set.
  # --------------------------------------------------------------------------
  character_set := |*
    ']' {
      self.emit(:character_set, :close, data[ts..te-1].pack('c*'), ts, te)
      fret;
    };

    '^' {
      self.emit(:character_set, :negate, data[ts..te-1].pack('c*'), ts, te)
    };

    alnum . '-' . alnum { # TODO: add properties
      self.emit(:character_set, :range, data[ts..te-1].pack('c*'), ts, te)
    };

    '&&' {
      self.emit(:character_set, :intersection, data[ts..te-1].pack('c*'), ts, te)
    };

    '\\' . [\]\-\,b] {
      self.emit(:character_set, :member, data[ts..te-1].pack('c*'), ts, te)
    };

    posix_class {
      case text = data[ts..te-1].pack('c*')
      when '[:alnum:]';  self.emit(:character_set, :set_class_alnum,  text, ts, te)
      when '[:alpha:]';  self.emit(:character_set, :set_class_alpha,  text, ts, te)
      when '[:blank:]';  self.emit(:character_set, :set_class_blank,  text, ts, te)
      when '[:cntrl:]';  self.emit(:character_set, :set_class_cntrl,  text, ts, te)
      when '[:digit:]';  self.emit(:character_set, :set_class_digit,  text, ts, te)
      when '[:graph:]';  self.emit(:character_set, :set_class_graph,  text, ts, te)
      when '[:lower:]';  self.emit(:character_set, :set_class_lower,  text, ts, te)
      when '[:print:]';  self.emit(:character_set, :set_class_print,  text, ts, te)
      when '[:punct:]';  self.emit(:character_set, :set_class_punct,  text, ts, te)
      when '[:space:]';  self.emit(:character_set, :set_class_space,  text, ts, te)
      when '[:upper:]';  self.emit(:character_set, :set_class_upper,  text, ts, te)
      when '[:xdigit:]'; self.emit(:character_set, :set_class_xdigit, text, ts, te)
      when '[:word:]';   self.emit(:character_set, :set_class_word,   text, ts, te)
      when '[:ascii:]';  self.emit(:character_set, :set_class_ascii,  text, ts, te)
      else raise "Unsupported character posixe class at #{text} (char #{ts})"
      end
    };

    any {
      self.emit(:character_set, :member, data[ts..te-1].pack('c*'), ts, te)
    };
  *|;


  # escape sequence scanner
  # --------------------------------------------------------------------------
  escape_sequence := |*
    hex_sequence {
      self.emit(:escape_sequence, :hex, data[ts..te-1].pack('c*'), ts, te)
      fret;
    };

    wide_hex_sequence {
      self.emit(:escape_sequence, :hex_wide, data[ts..te-1].pack('c*'), ts, te)
      fret;
    };

    control_sequence {
      self.emit(:escape_sequence, :control, data[ts..te-1].pack('c*'), ts, te)
      fret;
    };

    meta_sequence {
      self.emit(:escape_sequence, :meta, data[ts..te-1].pack('c*'), ts, te)
      fret;
    };

    meta_control_sequence {
      self.emit(:escape_sequence, :meta_control, data[ts..te-1].pack('c*'), ts, te)
      fret;
    };

    # TODO: extract into a separate machine... use in sets
    property_char . '{' . (property_name | general_category) . '}' > (escaped_alpha, 2) {
      text = data[ts..te-1].pack('c*')
      type = text[0,1] == 'p' ? :property: :inverted_property

      case name = data[ts+2..te-2].pack('c*')

      # Named
      when 'Alnum';   self.emit(type, :alnum,  text, ts, te)
      when 'Alpha';   self.emit(type, :alpha,  text, ts, te)
      when 'Any';     self.emit(type, :any,    text, ts, te)
      when 'Ascii';   self.emit(type, :ascii,  text, ts, te)
      when 'Blank';   self.emit(type, :blank,  text, ts, te)
      when 'Cntrl';   self.emit(type, :cntrl,  text, ts, te)
      when 'Digit';   self.emit(type, :digit,  text, ts, te)
      when 'Graph';   self.emit(type, :graph,  text, ts, te)
      when 'Lower';   self.emit(type, :lower,  text, ts, te)
      when 'Print';   self.emit(type, :print,  text, ts, te)
      when 'Punct';   self.emit(type, :punct,  text, ts, te)
      when 'Space';   self.emit(type, :space,  text, ts, te)
      when 'Upper';   self.emit(type, :upper,  text, ts, te)
      when 'Word';    self.emit(type, :word,   text, ts, te)
      when 'Xdigit';  self.emit(type, :xdigit, text, ts, te)

      # Letters
      when 'L';  self.emit(type, :letter_any,       text, ts, te)
      when 'Lu'; self.emit(type, :letter_uppercase, text, ts, te)
      when 'Ll'; self.emit(type, :letter_lowercase, text, ts, te)
      when 'Lt'; self.emit(type, :letter_titlecase, text, ts, te)
      when 'Lm'; self.emit(type, :letter_modifier,  text, ts, te)
      when 'Lo'; self.emit(type, :letter_other,     text, ts, te)

      # Marks
      when 'M';  self.emit(type, :mark_any,         text, ts, te)
      when 'Mn'; self.emit(type, :mark_nonspacing,  text, ts, te)
      when 'Mc'; self.emit(type, :mark_spacing,     text, ts, te)
      when 'Me'; self.emit(type, :mark_enclosing,   text, ts, te)

      # Numbers
      when 'N';  self.emit(type, :number_any,       text, ts, te)
      when 'Nd'; self.emit(type, :number_decimal,   text, ts, te)
      when 'Nl'; self.emit(type, :number_letter,    text, ts, te)
      when 'No'; self.emit(type, :number_other,     text, ts, te)

      # Punctuation
      when 'P';  self.emit(type, :punct_any,        text, ts, te)
      when 'Pc'; self.emit(type, :punct_connector,  text, ts, te)
      when 'Pd'; self.emit(type, :punct_dash,       text, ts, te)
      when 'Ps'; self.emit(type, :punct_open,       text, ts, te)
      when 'Pe'; self.emit(type, :punct_close,      text, ts, te)
      when 'Pi'; self.emit(type, :punct_initial,    text, ts, te)
      when 'Pf'; self.emit(type, :punct_final,      text, ts, te)
      when 'Po'; self.emit(type, :punct_other,      text, ts, te)

      # Symbols
      when 'S';  self.emit(type, :symbol_any,       text, ts, te)
      when 'Sm'; self.emit(type, :symbol_math,      text, ts, te)
      when 'Sc'; self.emit(type, :symbol_currency,  text, ts, te)
      when 'Sk'; self.emit(type, :symbol_modifier,  text, ts, te)
      when 'So'; self.emit(type, :symbol_other,     text, ts, te)

      # Separators
      when 'Z';  self.emit(type, :separator_any,        text, ts, te)
      when 'Zs'; self.emit(type, :separator_space,      text, ts, te)
      when 'Zl'; self.emit(type, :separator_line,       text, ts, te)
      when 'Zp'; self.emit(type, :separator_paragraph,  text, ts, te)

      # Codepoints
      when 'C';  self.emit(type, :code_any,         text, ts, te)
      when 'Cc'; self.emit(type, :code_control,     text, ts, te)
      when 'Cf'; self.emit(type, :code_format,      text, ts, te)
      when 'Cs'; self.emit(type, :code_surrogate,   text, ts, te)
      when 'Co'; self.emit(type, :code_private,     text, ts, te)
      when 'Cn'; self.emit(type, :code_unassigned,  text, ts, te)
      end
    };

    any > (escaped_alpha, 1)  {
      self.emit(:escape_sequence, :literal, data[ts..te-1].pack('c*'), ts, te)
      fret;
    };
  *|;


  # Main scanner
  # --------------------------------------------------------------------------
  main := |*

    # Meta characters
    alternation {
      self.emit(:meta, :alternation, data[ts..te-1].pack('c*'), ts, te)
    };

    wild {
      self.emit(:meta, :wild, data[ts..te-1].pack('c*'), ts, te)
    };

    # Character types
    #   \d, \D    digit, non-digit
    #   \h, \H    hex, non-hex
    #   \s, \S    whitespace, non-whitespace
    #   \w, \W    word, non-word
    # ------------------------------------------------------------------------
    backslash . char_type > (backslashed, 2) {
      case text = data[ts..te-1].pack('c*')
      when '\\d'; self.emit(:type, :digit,      text, ts, te)
      when '\\D'; self.emit(:type, :nondigit,   text, ts, te)
      when '\\h'; self.emit(:type, :hex,        text, ts, te)
      when '\\H'; self.emit(:type, :nonhex,     text, ts, te)
      when '\\s'; self.emit(:type, :space,      text, ts, te)
      when '\\S'; self.emit(:type, :nonspace,   text, ts, te)
      when '\\w'; self.emit(:type, :word,       text, ts, te)
      when '\\W'; self.emit(:type, :nonword,    text, ts, te)
      end
    };

    # Anchors
    beginning_of_line {
      self.emit(:anchor, :beginning_of_line, data[ts..te-1].pack('c*'), ts, te)
    };

    end_of_line {
      self.emit(:anchor, :end_of_line, data[ts..te-1].pack('c*'), ts, te)
    };

    backslash . anchor_char > (backslashed, 3) {
      case text = data[ts..te-1].pack('c*')
      when '\\A'; self.emit(:anchor, :bos,                text, ts, te)
      when '\\z'; self.emit(:anchor, :eos,                text, ts, te)
      when '\\Z'; self.emit(:anchor, :eos_or_before_eol,  text, ts, te)
      when '\\b'; self.emit(:anchor, :word_boundary,      text, ts, te)
      when '\\B'; self.emit(:anchor, :nonword_boundary,   text, ts, te)
      else raise "Unsupported anchor at #{text} (char #{ts})"
      end
    };

    # Escaped sequences
    backslash > (backslashed, 1) {
      fcall escape_sequence;
    };

    # Character sets
    set_open {
      self.emit(:character_set, :open, data[ts..te-1].pack('c*'), ts, te)
      fcall character_set;
    };

    # (?#...) comments: parsed as a single expression, without introducing a
    # new nesting level. Comments may not include parentheses, escaped or not.
    group_open . group_comment {
      self.emit(:group, :comment, data[ts..te-1].pack('c*'), ts, te)
    };

    # (?mix-mix...) expression options:
    #   (?imx-imx)          option on/off
    #                         i: ignore case
    #                         m: multi-line (dot(.) match newline)
    #                         x: extended form
    #
    #   (?imx-imx:subexp)   option on/off for subexp
    group_open . group_options {
      self.emit(:group, :options, data[ts..te-1].pack('c*'), ts, te)
    };

    # Assertions
    #   (?=subexp)          look-ahead
    #   (?!subexp)          negative look-ahead
    #   (?<=subexp)         look-behind
    #   (?<!subexp)         negative look-behind
    # ------------------------------------------------------------------------
    group_open . assertion_type {
      case text =  data[ts..te-1].pack('c*')
      when '(?=';  self.emit(:assertion, :lookahead,    text, ts, te)
      when '(?!';  self.emit(:assertion, :nlookahead,   text, ts, te)
      when '(?<='; self.emit(:assertion, :lookbehind,   text, ts, te)
      when '(?<!'; self.emit(:assertion, :nlookbehind,  text, ts, te)
      end
    };

    # Groups
    #   (?:subexp)          passive (non-captured) group
    #   (?>subexp)          atomic group, don't backtrack in subexp.
    #   (?<name>subexp)     named group (single quotes are no supported, yet)
    #   (subexp)            captured group
    # ------------------------------------------------------------------------
    group_open . group_type {
      case text =  data[ts..te-1].pack('c*')
      when '(?:';  self.emit(:group, :passive,      text, ts, te)
      when '(?>';  self.emit(:group, :atomic,       text, ts, te)
      when /\(\?<\w+>/
        self.emit(:group, :named, text, ts, te)
      end
    };

    group_open  {
      text =  data[ts..te-1].pack('c*')
      self.emit(:group, :capture, text, ts, te)
    };

    group_close {
      self.emit(:group, :close, data[ts..te-1].pack('c*'), ts, te)
    };


    # Quantifiers
    # ------------------------------------------------------------------------
    zero_or_one {
      case text =  data[ts..te-1].pack('c*')
      when '?' ;  self.emit(:quantifier, :zero_or_one,            text, ts, te)
      when '??';  self.emit(:quantifier, :zero_or_one_reluctant,  text, ts, te)
      when '?+';  self.emit(:quantifier, :zero_or_one_possessive, text, ts, te)
      end
    };
  
    zero_or_more {
      case text =  data[ts..te-1].pack('c*')
      when '*' ;  self.emit(:quantifier, :zero_or_more,            text, ts, te)
      when '*?';  self.emit(:quantifier, :zero_or_more_reluctant,  text, ts, te)
      when '*+';  self.emit(:quantifier, :zero_or_more_possessive, text, ts, te)
      end
    };
  
    one_or_more {
      case text =  data[ts..te-1].pack('c*')
      when '+' ;  self.emit(:quantifier, :one_or_more,            text, ts, te)
      when '+?';  self.emit(:quantifier, :one_or_more_reluctant,  text, ts, te)
      when '++';  self.emit(:quantifier, :one_or_more_possessive, text, ts, te)
      end
    };


    # Intervals: min, max, and exact notations
    # ------------------------------------------------------------------------
    range_open . (digit+)? . ','? . (digit+)? . range_close . quantifier_mode? {
      self.emit(:quantifier, :interval, data[ts..te-1].pack('c*'), ts, te)
    };


    # Literal: anything, except meta characters. This includes 2, 3, and 4
    # unicode byte sequences.
    # ------------------------------------------------------------------------
    (any - meta_char)+ {
      self.emit(:literal, :literal, data[ts..te-1].pack('c*'), ts, te)
    };

  *|;
}%%
