%%{
  machine re_scanner;
  include re_property "property.rl";

  dot                   = '.';
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


  class_posix           = '[:' . class_name_posix . ':]';

  char_type             = [dDhHsSwW];

  line_anchor           = beginning_of_line | end_of_line;
  anchor_char           = [AbBzZG];

  escaped_ascii         = [abefnrstv];
  octal_sequence        = [0-7]{1,3};

  hex_sequence          = 'x' . xdigit{1,2};
  wide_hex_sequence     = 'x' . '{' . xdigit{1,8} . '}';

  codepoint_single      = 'u' . xdigit{4};
  codepoint_list        = 'u{' . (xdigit{4} . space?)+'}';
  codepoint_sequence    = codepoint_single | codepoint_list;

  control_sequence      = ('c' | 'C-') . alpha;
  meta_sequence         = 'M-' . ((backslash . control_sequence) | alpha);

  zero_or_one           = '?' | '??' | '?+';
  zero_or_more          = '*' | '*?' | '*+';
  one_or_more           = '+' | '+?' | '++';

  quantifier_greedy     = '?'  | '*'  | '+';
  quantifier_reluctant  = '??' | '*?' | '+?';
  quantifier_possessive = '?+' | '*+' | '++';
  quantifier_mode       = '?'  | '+';

  quantifier_range      = range_open . (digit+)? . ','? . (digit+)? .
                          range_close . quantifier_mode?;

  quantifier_range_bre  = backslash . range_open . (digit+)? . ','? . (digit+)? .
                          backslash . range_close;

  quantifiers           = quantifier_greedy | quantifier_reluctant |
                          quantifier_possessive | quantifier_range;


  group_comment         = '?#' . [^)]+ . group_close;

  group_atomic          = '?>';
  group_passive         = '?:';

  assertion_lookahead   = '?=';
  assertion_nlookahead  = '?!';
  assertion_lookbehind  = '?<=';
  assertion_nlookbehind = '?<!';

  group_options         = '?' . ([mix]{1,3})? . '-'? . ([mix]{1,3})?;

  group_ref             = [gk];
  group_name            = alpha . (alnum+)?;
  group_named           = ('?<' . group_name . '>') | ("?'" . group_name . "'");
  group_name_ref        = group_ref . (('<' . group_name . '>') | ("'" . group_name . "'"));

  group_number          = '-'? . [1-9] . ([0-9]+)?;
  group_number_ref      = group_ref . (('<' . group_number . '>') | ("'" . group_number . "'"));

  group_type            = group_atomic | group_passive | group_named;

  assertion_type        = assertion_lookahead  | assertion_nlookahead |
                          assertion_lookbehind | assertion_nlookbehind;

  # characters that 'break' a literal
  meta_char             = dot | backslash | alternation |
                          curlies | parantheses | brackets |
                          line_anchor | quantifier_greedy;

  ascii_print           = ((0x20..0x7e) - meta_char)+;
  ascii_nonprint        = (0x01..0x1f | 0x7f)+;

  utf8_2_byte           = (0xc2..0xdf 0x80..0xbf)+;
  utf8_3_byte           = (0xe0..0xef 0x80..0xbf 0x80..0xbf)+;
  utf8_4_byte           = (0xf0..0xf4 0x80..0xbf 0x80..0xbf 0x80..0xbf)+;
  utf8_byte_sequence    = utf8_2_byte | utf8_3_byte | utf8_4_byte;

  non_literal_escape    = char_type | anchor_char | escaped_ascii |
                          group_ref | [xucCM];

  # EOF error, used where it can be detected
  action premature_end_error { raise "Premature end of pattern" }

  # group (nesting) and set open/close actions
  action group_opened { group_depth += 1; in_group = true }
  action group_closed { group_depth -= 1; in_group = group_depth > 0 ? true : false }

  action set_opened { set_depth += 1; in_set = true }
  action set_closed { set_depth -= 1; in_set = set_depth > 0 ? true : false }


  # Character set scanner, continues consuming characters until it meets the
  # closing bracket of the set.
  # --------------------------------------------------------------------------
  character_set := |*
    ']' %set_closed {
      self.emit(:set, :close, data[ts..te-1].pack('c*'), ts, te)
      fret;
    };

    '-]' %set_closed { # special case, emits two tokens
      self.emit(:set, :member, data[ts..te-2].pack('c*'), ts, te)
      self.emit(:set, :close,  data[ts+1..te-1].pack('c*'), ts, te)
      fret;
    };

    '^' {
      text = data[ts..te-1].pack('c*')
      if @tokens.last[1] == :open
        self.emit(:set, :negate, text, ts, te)
      else
        self.emit(:set, :member, text, ts, te)
      end
    };

    alnum . '-' . alnum {
      self.emit(:set, :range, data[ts..te-1].pack('c*'), ts, te)
    };

    '&&' {
      self.emit(:set, :intersection, data[ts..te-1].pack('c*'), ts, te)
    };

    '\\' {
      fcall set_escape_sequence;
    };

    class_posix @err(premature_end_error) {
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

    # exclude the closing bracket as a cleaner workaround for dealing with the
    # ambiguity caused upon exit from the unicode properties machine
    meta_char -- ']' {
     self.emit(:set, :member, data[ts..te-1].pack('c*'), ts, te)
    };

    any            |
    ascii_nonprint |
    utf8_2_byte    |
    utf8_3_byte    |
    utf8_4_byte    {
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

    char_type {
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

    meta_char | [\\\]\-\,] {
      self.emit(:set, :escape, data[ts-1..te-1].pack('c*'), ts-1, te)
      fret;
    };

    property_char > (escaped_set_alpha, 2) {
      fhold;
      fnext character_set;
      fcall unicode_property;
      fret;
    };

    # special case exclusion of escaped dash, could be cleaner.
    (ascii_print - char_type -- [\-}]) > (escaped_set_alpha, 1) |
    ascii_nonprint            |
    utf8_2_byte               |
    utf8_3_byte               |
    utf8_4_byte               {
      self.emit(:set, :escape, data[ts-1..te-1].pack('c*'), ts-1, te)
      fret;
    };
  *|;


  # escape sequence scanner
  # --------------------------------------------------------------------------
  escape_sequence := |*
    [1-9] {
      text = data[ts-1..te-1].pack('c*')
      self.emit(:backref, :digit, text, ts-1, te)
      fret;
    };

    octal_sequence {
      self.emit(:escape, :octal, data[ts-1..te-1].pack('c*'), ts-1, te)
      fret;
    };

    meta_char {
      case text = data[ts-1..te-1].pack('c*')
      when '\.';  self.emit(:escape, :dot,               text, ts-1, te)
      when '\|';  self.emit(:escape, :alternation,       text, ts-1, te)
      when '\^';  self.emit(:escape, :beginning_of_line, text, ts-1, te)
      when '\$';  self.emit(:escape, :end_of_line,       text, ts-1, te)
      when '\?';  self.emit(:escape, :zero_or_one,       text, ts-1, te)
      when '\*';  self.emit(:escape, :zero_or_more,      text, ts-1, te)
      when '\+';  self.emit(:escape, :one_or_more,       text, ts-1, te)
      when '\(';  self.emit(:escape, :group_open,        text, ts-1, te)
      when '\)';  self.emit(:escape, :group_close,       text, ts-1, te)
      when '\{';  self.emit(:escape, :interval_open,     text, ts-1, te)
      when '\}';  self.emit(:escape, :interval_close,    text, ts-1, te)
      when '\[';  self.emit(:escape, :set_open,          text, ts-1, te)
      when '\]';  self.emit(:escape, :set_close,         text, ts-1, te)
      when "\\\\";
        self.emit(:escape, :backslash, text, ts-1, te)
      end
      fret;
    };

    escaped_ascii > (escaped_alpha, 7) {
      # \b is emitted as backspace only when inside a character set, otherwise
      # it is a word boundary anchor. A syntax might "normalize" it if needed.
      case text = data[ts-1..te-1].pack('c*')
      when '\a'; self.emit(:escape, :bell,           text, ts-1, te)
      when '\e'; self.emit(:escape, :escape,         text, ts-1, te)
      when '\f'; self.emit(:escape, :form_feed,      text, ts-1, te)
      when '\n'; self.emit(:escape, :newline,        text, ts-1, te)
      when '\r'; self.emit(:escape, :carriage,       text, ts-1, te)
      when '\s'; self.emit(:escape, :space,          text, ts-1, te)
      when '\t'; self.emit(:escape, :tab,            text, ts-1, te)
      when '\v'; self.emit(:escape, :vertical_tab,   text, ts-1, te)
      end
      fret;
    };

    codepoint_sequence > (escaped_alpha, 6) {
      text = data[ts-1..te-1].pack('c*')
      if text[2].chr == '{'
        self.emit(:escape, :codepoint_list, text, ts-1, te)
      else
        self.emit(:escape, :codepoint,      text, ts-1, te)
      end
      fret;
    };

    hex_sequence > (escaped_alpha, 5) {
      self.emit(:escape, :hex, data[ts-1..te-1].pack('c*'), ts-1, te)
      fret;
    };

    wide_hex_sequence > (escaped_alpha, 5) {
      self.emit(:escape, :hex_wide, data[ts-1..te-1].pack('c*'), ts-1, te)
      fret;
    };

    control_sequence > (escaped_alpha, 4) {
      self.emit(:escape, :control, data[ts-1..te-1].pack('c*'), ts-1, te)
      fret;
    };

    meta_sequence > (backslashed, 3) {
      self.emit(:escape, :meta_sequence, data[ts-1..te-1].pack('c*'), ts-1, te)
    };

    property_char > (escaped_alpha, 2) {
      fhold; fcall unicode_property; fret;
    };

    (any -- non_literal_escape) > (escaped_alpha, 1)  {
      self.emit(:escape, :literal, data[ts-1..te-1].pack('c*'), ts-1, te)
      fret;
    };
  *|;


  # Main scanner
  # --------------------------------------------------------------------------
  main := |*

    # Meta characters
    # ------------------------------------------------------------------------
    dot {
      self.emit(:meta, :dot, data[ts..te-1].pack('c*'), ts, te)
    };

    alternation {
      self.emit(:meta, :alternation, data[ts..te-1].pack('c*'), ts, te)
    };

    # Anchors
    # ------------------------------------------------------------------------
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
      when '\\Z'; self.emit(:anchor, :eos_ob_eol,         text, ts, te)
      when '\\b'; self.emit(:anchor, :word_boundary,      text, ts, te)
      when '\\B'; self.emit(:anchor, :nonword_boundary,   text, ts, te)
      else raise "Unsupported anchor at #{text} (char #{ts})"
      end
    };

    # Character types
    #   \d, \D    digit, non-digit
    #   \h, \H    hex, non-hex
    #   \s, \S    space, non-space
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


    # Character sets
    # ------------------------------------------------------------------------
    set_open %set_opened  {
      self.emit(:set, :open, data[ts..te-1].pack('c*'), ts, te)
      fcall character_set;
    };

    # (?#...) comments: parsed as a single expression, without introducing a
    # new nesting level. Comments may not include parentheses, escaped or not.
    # special case for close, action performed on all transitions to get the 
    # correct closing count.
    # ------------------------------------------------------------------------
    group_open . group_comment $group_closed {
      self.emit(:group, :comment, data[ts..te-1].pack('c*'), ts, te)
    };

    # Expression options:
    #   (?imx-imx)          option on/off
    #                         i: ignore case
    #                         m: multi-line (dot(.) match newline)
    #                         x: extended form
    #
    #   (?imx-imx:subexp)   option on/off for subexp
    # ------------------------------------------------------------------------
    group_open . group_options >group_opened {
      # special handling to resolve ambiguity with passive groups
      if data[te]
        c = data[te].chr
        if c == ':' # include the ':'
          self.emit(:group, :options, data[ts..te].pack('c*'), ts, te+1)
          p += 1
        elsif c == ')' # just options by themselves
          self.emit(:group, :options, data[ts..te-1].pack('c*'), ts, te)
        else
          raise "Unexpected '#{c}' in options sequene, expected ':' or ')'"
        end
      else
        raise "Premature end of pattern" unless data[te]
      end
    };

    # Assertions
    #   (?=subexp)          look-ahead
    #   (?!subexp)          negative look-ahead
    #   (?<=subexp)         look-behind
    #   (?<!subexp)         negative look-behind
    # ------------------------------------------------------------------------
    group_open . assertion_type >group_opened {
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
    #   (?<name>subexp)     named group
    #   (?'name'subexp)     named group (single quoted version)
    #   (subexp)            captured group
    # ------------------------------------------------------------------------
    group_open . group_type >group_opened {
      case text =  data[ts..te-1].pack('c*')
      when '(?:';  self.emit(:group, :passive,      text, ts, te)
      when '(?>';  self.emit(:group, :atomic,       text, ts, te)

      when /\(\?<\w+>/
        self.emit(:group, :named,     text, ts, te)
      when /\(\?'\w+'/
        self.emit(:group, :named_sq,  text, ts, te)
      end
    };

    group_open @group_opened {
      text =  data[ts..te-1].pack('c*')
      self.emit(:group, :capture, text, ts, te)
    };

    group_close @group_closed {
      self.emit(:group, :close, data[ts..te-1].pack('c*'), ts, te)
    };


    # Group back-reference, named and numbered
    # ------------------------------------------------------------------------
    backslash . (group_name_ref | group_number_ref) > (backslashed, 4) {
      case text = data[ts..te-1].pack('c*')
      when /\\([gk])<[^\d-](\w+)?>/ # angle-brackets
        if $1 == 'k'
          self.emit(:backref, :name_ref_ab,  text, ts, te)
        else
          self.emit(:backref, :name_call_ab,  text, ts, te)
        end

      when /\\([gk])'[^\d-](\w+)?'/ #single quotes
        if $1 == 'k'
          self.emit(:backref, :name_ref_sq,  text, ts, te)
        else
          self.emit(:backref, :name_call_sq,  text, ts, te)
        end

      when /\\([gk])<\d+>/ # angle-brackets
        if $1 == 'k'
          self.emit(:backref, :number_ref_ab,  text, ts, te)
        else
          self.emit(:backref, :number_call_ab,  text, ts, te)
        end

      when /\\([gk])'\d+'/ # single quotes
        if $1 == 'k'
          self.emit(:backref, :number_ref_sq,  text, ts, te)
        else
          self.emit(:backref, :number_call_sq,  text, ts, te)
        end

      when /\\([gk])<-\d+>/ # angle-brackets
        if $1 == 'k'
          self.emit(:backref, :number_rel_ref_ab,  text, ts, te)
        else
          self.emit(:backref, :number_rel_call_ab,  text, ts, te)
        end

      when /\\([gk])'-\d+'/ # single quotes
        if $1 == 'k'
          self.emit(:backref, :number_rel_ref_sq,  text, ts, te)
        else
          self.emit(:backref, :number_rel_call_sq,  text, ts, te)
        end
      end
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

    quantifier_range  @err(premature_end_error) {
      self.emit(:quantifier, :interval, data[ts..te-1].pack('c*'), ts, te)
    };

    # BRE version
    quantifier_range_bre  @err(premature_end_error) {
      self.emit(:quantifier, :interval_bre, data[ts..te-1].pack('c*'), ts, te)
    };

    # Escaped sequences
    # ------------------------------------------------------------------------
    backslash > (backslashed, 1) {
      fcall escape_sequence;
    };

    # Literal: any run of ASCII (pritable or non-printable), and/or UTF-8,
    # except meta characters.
    # ------------------------------------------------------------------------
    ascii_print+    |
    ascii_nonprint+ |
    utf8_2_byte+    |
    utf8_3_byte+    |
    utf8_4_byte+    {
      self.append_literal(data, ts, te)
    };

  *|;
}%%


module Regexp::Scanner
  %% write data;

  # Scans the given regular expression text, or Regexp object and collects the
  # emitted token into an array that gets returned at the end. If a block is
  # given, it gets called for each emitted token.
  #
  # This method may raise errors if a syntax error is encountered.
  # --------------------------------------------------------------------------
  def self.scan(input, &block)
    top, stack = 0, []

    input = input.source if input.is_a?(Regexp)
    data  = input.unpack("c*") if input.is_a?(String)
    eof   = data.length

    @tokens = []
    @block  = block_given? ? block : nil

    in_group, group_depth = false, 0
    in_set,   set_depth   = false, 0

    %% write init;
    %% write exec;

    raise "Premature end of pattern (missing group closing paranthesis) "+
      "[#{in_group}:#{group_depth}]" if in_group
    raise "Premature end of pattern (missing set closing bracket) "+
      "[#{in_set}:#{set_depth}]" if in_set

    # when the entire expression is a literal run
    self.emit_literal if @literal

    @tokens
  end

  # appends one or more characters to the literal buffer, to be emitted later
  # by a call to emit_literal. contents a mix of ASCII and UTF-8
  def self.append_literal(data, ts, te)
    @literal ||= []
    @literal << [data[ts..te-1].pack('c*'), ts, te]
  end

  # emits the collected literal run collected by one or more calls to the 
  # append_literal method
  def self.emit_literal
    ts, te = @literal.first[1], @literal.last[2]
    text = @literal.map {|t| t[0]}.join

    text.force_encoding('utf-8') if text.respond_to?(:force_encoding)

    self.emit(:literal, :literal, text, ts, te)
    @literal = nil
  end

  def self.emit(type, token, text, ts, te)
    #puts " > emit: #{type}:#{token} '#{text}' [#{ts}..#{te}]"

    if @literal and type != :literal
      self.emit_literal
    end

    if @block
      @block.call type, token, text, ts, te
    end

    @tokens << [type, token, text, ts, te]
  end

end # module Regexp::Scanner
