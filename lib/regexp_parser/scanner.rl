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

  class_name_posix      = 'alnum' | 'alpha' | 'blank' |
                          'cntrl' | 'digit' | 'graph' |
                          'lower' | 'print' | 'punct' |
                          'space' | 'upper' | 'xdigit' |
                          'word'  | 'ascii';

  property_name_unicode = 'Alnum' | 'Alpha' | 'Any'   | 'Ascii' | 'Blank' |
                          'Cntrl' | 'Digit' | 'Graph' | 'Lower' | 'Print' |
                          'Punct' | 'Space' | 'Upper' | 'Word' | 'Xdigit';

  property_name_ruby    = 'Any' | 'Assigned' | 'Newline';

  property_name         = property_name_unicode | property_name_ruby;


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

  class_posix           = '[:' . class_name_posix . ':]';

  char_type             = [dDhHsSwW];

  line_anchor           = beginning_of_line | end_of_line;
  anchor_char           = [AbBzZG];
  property_char         = [pP];

  escaped_char          = [abefnrstv];
  octal_sequence        = [0-7]{1,3};

  hex_sequence          = 'x' . xdigit{1,2};
  wide_hex_sequence     = 'x' . '{7' . xdigit{1,7} . '}';

  codepoint_single      = 'u' . xdigit{4};
  codepoint_list        = 'u{' . (xdigit{4} . space?)+'}';
  codepoint_sequence    = codepoint_single | codepoint_list;

  control_sequence      = ('c' | 'C-') . alpha;
  meta_sequence         = 'M-' . alpha;
  meta_control_sequence = 'M-\\C-' . alpha; # TODO: trace origin

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
  group_named           = ('?<' . group_name . '>') | ('?\'' . group_name . '\'');

  group_type            = group_atomic | group_passive | group_named;

  assertion_type        = assertion_lookahead  | assertion_nlookahead |
                          assertion_lookbehind | assertion_nlookbehind;

  # characters that 'break' a literal
  meta_char             = wild | backslash | alternation |
                          curlies | parantheses | brackets |
                          line_anchor | quantifier_greedy;


  # Character set scanner, continues consuming characters until it meets the
  # closing bracket of the set.
  # --------------------------------------------------------------------------
  character_set := |*
    ']' {
      self.emit(:set, :close, data[ts..te-1].pack('c*'), ts, te)
      fret;
    };

    '^' {
      self.emit(:set, :negate, data[ts..te-1].pack('c*'), ts, te)
    };

    alnum . '-' . alnum { # TODO: add properties
      self.emit(:set, :range, data[ts..te-1].pack('c*'), ts, te)
    };

    '&&' {
      self.emit(:set, :intersection, data[ts..te-1].pack('c*'), ts, te)
    };

    '\\' {
      fcall set_escape_sequence;
    };

    class_posix {
      case text = data[ts..te-1].pack('c*')
      when '[:alnum:]';  self.emit(:set, :class_alnum,  text, ts, te)
      when '[:alpha:]';  self.emit(:set, :class_alpha,  text, ts, te)
      when '[:ascii:]';  self.emit(:set, :class_ascii,  text, ts, te)
      when '[:blank:]';  self.emit(:set, :class_blank,  text, ts, te)
      when '[:cntrl:]';  self.emit(:set, :class_cntrl,  text, ts, te)
      when '[:digit:]';  self.emit(:set, :class_digit,  text, ts, te)
      when '[:graph:]';  self.emit(:set, :class_graph,  text, ts, te)
      when '[:lower:]';  self.emit(:set, :class_lower,  text, ts, te)
      when '[:print:]';  self.emit(:set, :class_print,  text, ts, te)
      when '[:punct:]';  self.emit(:set, :class_punct,  text, ts, te)
      when '[:space:]';  self.emit(:set, :class_space,  text, ts, te)
      when '[:upper:]';  self.emit(:set, :class_upper,  text, ts, te)
      when '[:word:]';   self.emit(:set, :class_word,   text, ts, te)
      when '[:xdigit:]'; self.emit(:set, :class_xdigit, text, ts, te)
      else raise "Unsupported character posixe class at #{text} (char #{ts})"
      end
    };

    any {
      self.emit(:set, :member, data[ts..te-1].pack('c*'), ts, te)
    };
  *|;

  # set escapes scanner
  # --------------------------------------------------------------------------
  set_escape_sequence := |*
    'b' {
      self.emit(:set, :backspace, data[ts-1..te-1].pack('c*'), ts-1, te)
      fret;
    };

    [\\\]\-\,] {
      self.emit(:set, :escape, data[ts-1..te-1].pack('c*'), ts-1, te)
      fret;
    };

    [dDhHsSwW] {
      case text = data[ts-1..te-1].pack('c*')
      when '\d'; self.emit(:set, :type_digit,     text, ts-1, te)
      when '\D'; self.emit(:set, :type_nondigit,  text, ts-1, te)
      when '\h'; self.emit(:set, :type_hex,       text, ts-1, te)
      when '\H'; self.emit(:set, :type_nonhex,    text, ts-1, te)
      when '\s'; self.emit(:set, :type_space,     text, ts-1, te)
      when '\S'; self.emit(:set, :type_nonspace,  text, ts-1, te)
      when '\w'; self.emit(:set, :type_word,      text, ts-1, te)
      when '\W'; self.emit(:set, :type_nonword,   text, ts-1, te)
      end

      fret;
    };

    hex_sequence . '-\\' . hex_sequence {
      self.emit(:set, :range_hex, data[ts-1..te-1].pack('c*'), ts-1, te)
      fret;
    };

    hex_sequence {
      self.emit(:set, :member_hex, data[ts-1..te-1].pack('c*'), ts-1, te)
      fret;
    };
  *|;


  # escape sequence scanner
  # --------------------------------------------------------------------------
  escape_sequence := |*
    [1-9] {
      text = data[ts-1..te-1].pack('c*')
      self.emit(:backref, :digit, text, ts, te)
      fret;
    };

    codepoint_sequence {
      text = data[ts-1..te-1].pack('c*')
      if text[2].chr == '{'
        self.emit(:escape, :codepoint_list, data[ts-1..te-1].pack('c*'), ts, te)
      else
        self.emit(:escape, :codepoint, data[ts-1..te-1].pack('c*'), ts, te)
      end
      fret;
    };

    hex_sequence {
      self.emit(:escape, :hex, data[ts-1..te-1].pack('c*'), ts, te)
      fret;
    };

    # curly brackets
    wide_hex_sequence {
      self.emit(:escape, :hex_wide, data[ts-1..te-1].pack('c*'), ts, te)
      fret;
    };


    control_sequence {
      self.emit(:escape, :control, data[ts-1..te-1].pack('c*'), ts, te)
      fret;
    };

    meta_sequence {
      self.emit(:escape, :meta, data[ts-1..te-1].pack('c*'), ts, te)
      fret;
    };

    meta_control_sequence {
      self.emit(:escape, :meta_control, data[ts-1..te-1].pack('c*'), ts, te)
      fret;
    };

    # TODO: extract into a separate machine... use in sets
    property_char . '{' . (property_name | general_category) . '}' > (escaped_alpha, 4) {
      text = data[ts-1..te-1].pack('c*')

      # TODO: rename :inverted_property to :nonproperty
      type = text[1,1] == 'p' ? :property : :inverted_property
      # TODO: add ^ for property negation, :nonproperty_caret

      case name = data[ts+2..te-2].pack('c*').downcase

      # Named
      when 'alnum';   self.emit(type, :alnum,  text, ts, te)
      when 'alpha';   self.emit(type, :alpha,  text, ts, te)
      when 'any';     self.emit(type, :any,    text, ts, te)

      when 'ascii';   self.emit(type, :ascii,  text, ts, te)

      when 'blank';   self.emit(type, :blank,  text, ts, te)
      when 'cntrl';   self.emit(type, :cntrl,  text, ts, te)
      when 'digit';   self.emit(type, :digit,  text, ts, te)
      when 'graph';   self.emit(type, :graph,  text, ts, te)
      when 'lower';   self.emit(type, :lower,  text, ts, te)

      when 'print';   self.emit(type, :print,  text, ts, te)
      when 'punct';   self.emit(type, :punct,  text, ts, te)
      when 'space';   self.emit(type, :space,  text, ts, te)
      when 'upper';   self.emit(type, :upper,  text, ts, te)
      when 'word';    self.emit(type, :word,   text, ts, te)

      when 'xdigit';  self.emit(type, :xdigit, text, ts, te)

      when 'newline'; self.emit(type, :newline,  text, ts, te)

      # Letters
      when 'l';  self.emit(type, :letter_any,       text, ts, te)
      when 'lu'; self.emit(type, :letter_uppercase, text, ts, te)
      when 'll'; self.emit(type, :letter_lowercase, text, ts, te)
      when 'lt'; self.emit(type, :letter_titlecase, text, ts, te)
      when 'lm'; self.emit(type, :letter_modifier,  text, ts, te)
      when 'lo'; self.emit(type, :letter_other,     text, ts, te)

      # Marks
      when 'm';  self.emit(type, :mark_any,         text, ts, te)
      when 'mn'; self.emit(type, :mark_nonspacing,  text, ts, te)
      when 'mc'; self.emit(type, :mark_spacing,     text, ts, te)
      when 'me'; self.emit(type, :mark_enclosing,   text, ts, te)

      # Numbers
      when 'n';  self.emit(type, :number_any,       text, ts, te)
      when 'nd'; self.emit(type, :number_decimal,   text, ts, te)
      when 'nl'; self.emit(type, :number_letter,    text, ts, te)
      when 'no'; self.emit(type, :number_other,     text, ts, te)

      # Punctuation
      when 'p';  self.emit(type, :punct_any,        text, ts, te)
      when 'pc'; self.emit(type, :punct_connector,  text, ts, te)
      when 'pd'; self.emit(type, :punct_dash,       text, ts, te)
      when 'ps'; self.emit(type, :punct_open,       text, ts, te)
      when 'pe'; self.emit(type, :punct_close,      text, ts, te)
      when 'pi'; self.emit(type, :punct_initial,    text, ts, te)
      when 'pf'; self.emit(type, :punct_final,      text, ts, te)
      when 'po'; self.emit(type, :punct_other,      text, ts, te)

      # Symbols
      when 's';  self.emit(type, :symbol_any,       text, ts, te)
      when 'sm'; self.emit(type, :symbol_math,      text, ts, te)
      when 'sc'; self.emit(type, :symbol_currency,  text, ts, te)
      when 'sk'; self.emit(type, :symbol_modifier,  text, ts, te)
      when 'so'; self.emit(type, :symbol_other,     text, ts, te)

      # Separators
      when 'z';  self.emit(type, :separator_any,        text, ts, te)
      when 'zs'; self.emit(type, :separator_space,      text, ts, te)
      when 'zl'; self.emit(type, :separator_line,       text, ts, te)
      when 'zp'; self.emit(type, :separator_paragraph,  text, ts, te)

      # Codepoints
      when 'c';  self.emit(type, :codepoint_any,        text, ts, te)
      when 'cc'; self.emit(type, :codepoint_control,    text, ts, te)
      when 'cf'; self.emit(type, :codepoint_format,     text, ts, te)
      when 'cs'; self.emit(type, :codepoint_surrogate,  text, ts, te)
      when 'co'; self.emit(type, :codepoint_private,    text, ts, te)
      when 'cn'; self.emit(type, :codepoint_unassigned, text, ts, te)
      end
      fret;
    };

    curlies | parantheses > (escaped_alpha, 3)  {
      case text = data[ts..te-1].pack('c*')
      when '('; self.emit(:escape, :group_open,       text, ts, te)
      when ')'; self.emit(:escape, :group_close,      text, ts, te)
      when '{'; self.emit(:escape, :interval_open,    text, ts, te)
      when '}'; self.emit(:escape, :interval_close,   text, ts, te)
      end
      fret;
    };

    escaped_char > (escaped_alpha, 2) {
      case text = data[ts-1..te-1].pack('c*')
      when '\a'; self.emit(:escape, :bell,           text, ts, te)
      when '\b'; self.emit(:escape, :backspace,      text, ts, te)
      when '\e'; self.emit(:escape, :escape,         text, ts, te)
      when '\f'; self.emit(:escape, :form_feed,      text, ts, te)
      when '\n'; self.emit(:escape, :newline,        text, ts, te)
      when '\r'; self.emit(:escape, :carriage,       text, ts, te)
      when '\s'; self.emit(:escape, :space,          text, ts, te)
      when '\t'; self.emit(:escape, :tab,            text, ts, te)
      when '\v'; self.emit(:escape, :vertical_tab,   text, ts, te)
      end
      fret;
    };

    any > (escaped_alpha, 1)  {
      self.emit(:escape, :literal, data[ts-1..te-1].pack('c*'), ts, te)
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

    # Character types
    #     .       any
    #   \d, \D    digit, non-digit
    #   \h, \H    hex, non-hex
    #   \s, \S    space, non-space
    #   \w, \W    word, non-word
    # ------------------------------------------------------------------------
    wild {
      self.emit(:type, :any, data[ts..te-1].pack('c*'), ts, te)
    };

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
      self.emit(:set, :open, data[ts..te-1].pack('c*'), ts, te)
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
    # unicode byte sequences. TODO: verify
    # ------------------------------------------------------------------------
    (any - meta_char)+ {
      self.emit(:literal, :literal, data[ts..te-1].pack('c*'), ts, te)
    };

  *|;
}%%


module Regexp::Scanner
  %% write data;

  # Scans the given regular expression text, or Regexp object and:
  #
  # If a block is given, calls it for each emitted token, and returns nil
  # when done.
  #
  # If no block is given, collect the emitted arguments (as an array) into
  # an array and return that when done.
  #
  # This may raise an error if a syntax error is encountered. ** this is still
  # in progress.
  # --------------------------------------------------------------------------
  def self.scan(input, &block)
    top, stack = 0, []

    input = input.source if input.is_a?(Regexp)
    data  = input.unpack("c*") if input.is_a?(String)
    eof   = data.length

    @block  = block_given? ? block : nil
    @tokens = block_given? ? nil : []

    %% write init;
    %% write exec;

    @tokens
  end

  def self.emit(type, token, text, ts, te)
    #puts " > emit: #{type}:#{token} '#{text}' [#{ts}..#{te}]"

    if @block
      @block.call type, token, text, ts, te
    else
      @tokens << [type, token, text, ts, te]
    end
  end

end # module Regexp::Lexer
