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

  comment               = ('#' . [^\n]* . '\n');

  class_name_posix      = 'alnum' | 'alpha' | 'blank' |
                          'cntrl' | 'digit' | 'graph' |
                          'lower' | 'print' | 'punct' |
                          'space' | 'upper' | 'xdigit' |
                          'word'  | 'ascii';

  class_posix           = ('[:' . '^'? . class_name_posix . ':]');


  # these are not supported in ruby, and need verification
  collating_sequence    = '[.' . (alpha | [\-])+ . '.]';
  character_equivalent  = '[=' . alpha . '=]';

  char_type             = [dDhHsSwW];

  line_anchor           = beginning_of_line | end_of_line;
  anchor_char           = [AbBzZG];

  escaped_ascii         = [abefnrstv];
  octal_sequence        = [0-7]{1,3};

  hex_sequence          = 'x' . xdigit{1,2};
  hex_sequence_err      = 'x' . [^0-9a-fA-F{];
  wide_hex_sequence     = 'x' . '{' . xdigit{1,8} . '}';

  hex_or_not            = (xdigit|[^0-9a-fA-F}]); # note closing curly at end

  wide_hex_seq_invalid  = 'x' . '{' . hex_or_not{1,9};
  wide_hex_seq_empty    = 'x' . '{' . (space+)? . '}';

  codepoint_single      = 'u' . xdigit{4};
  codepoint_list        = 'u{' . xdigit{1,5} . (space . xdigit{1,5})* . '}';
  codepoint_sequence    = codepoint_single | codepoint_list;

  control_sequence      = ('c' | 'C-');

  meta_sequence         = 'M-' . (backslash . control_sequence)?;

  zero_or_one           = '?' | '??' | '?+';
  zero_or_more          = '*' | '*?' | '*+';
  one_or_more           = '+' | '+?' | '++';

  quantifier_greedy     = '?'  | '*'  | '+';
  quantifier_reluctant  = '??' | '*?' | '+?';
  quantifier_possessive = '?+' | '*+' | '++';
  quantifier_mode       = '?'  | '+';

  quantifier_interval   = range_open . (digit+)? . ','? . (digit+)? .
                          range_close . quantifier_mode?;

  quantifiers           = quantifier_greedy | quantifier_reluctant |
                          quantifier_possessive | quantifier_interval;


  conditional           = '(?(';

  group_comment         = '?#' . [^)]* . group_close;

  group_atomic          = '?>';
  group_passive         = '?:';
  group_absence         = '?~';

  assertion_lookahead   = '?=';
  assertion_nlookahead  = '?!';
  assertion_lookbehind  = '?<=';
  assertion_nlookbehind = '?<!';

  group_options         = '?' . [\-mixdau];

  group_ref             = [gk];
  group_name_char       = (alnum | '_');
  group_name_id         = (group_name_char . (group_name_char+)?)?;
  group_number          = '-'? . [1-9] . ([0-9]+)?;
  group_level           = [+\-] . [0-9]+;

  group_name            = ('<' . group_name_id . '>') | ("'" . group_name_id . "'");
  group_lookup          = group_name | group_number;

  group_named           = ('?' . group_name );

  group_name_ref        = group_ref . (('<' . group_name_id . group_level? '>') |
                                       ("'" . group_name_id . group_level? "'"));

  group_number_ref      = group_ref . (('<' . group_number . group_level? '>') |
                                       ("'" . group_number . group_level? "'"));

  group_type            = group_atomic | group_passive | group_absence | group_named;


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
  action premature_end_error {
    text = ts ? copy(data, ts-1..-1) : data.pack('c*')
    raise PrematureEndError.new( text )
  }

  # Invalid sequence error, used from sequences, like escapes and sets
  action invalid_sequence_error {
    text = ts ? copy(data, ts-1..-1) : data.pack('c*')
    raise InvalidSequenceError.new('sequence', text)
  }

  # group (nesting) and set open/close actions
  action group_opened { @group_depth += 1; @in_group = true }
  action group_closed { @group_depth -= 1; @in_group = @group_depth > 0 ? true : false }

  # Character set scanner, continues consuming characters until it meets the
  # closing bracket of the set.
  # --------------------------------------------------------------------------
  character_set := |*
    ']' {
      set_type  = set_depth > 1 ? :subset : :set
      set_depth -= 1; in_set = set_depth > 0 ? true : false

      emit(set_type, :close, *text(data, ts, te))

      if set_depth == 0
        fgoto main;
      else
        fret;
      end
    };

    '-]' { # special case, emits two tokens
      set_type  = set_depth > 1 ? :subset : :set
      set_depth -= 1; in_set = set_depth > 0 ? true : false

      emit(set_type, :member, copy(data, ts..te-2), ts, te)
      emit(set_type, :close,  copy(data, ts+1..te-1), ts, te)

      if set_depth == 0
        fgoto main;
      else
        fret;
      end
    };

    '^' {
      text = text(data, ts, te).first
      if @tokens.last[1] == :open
        emit(set_type, :negate, text, ts, te)
      else
        emit(set_type, :member, text, ts, te)
      end
    };

    alnum . '-' . alnum {
      emit(set_type, :range, *text(data, ts, te))
    };

    '&&' {
      emit(set_type, :intersection, *text(data, ts, te))
    };

    '\\' {
      fcall set_escape_sequence;
    };

    '[' >(open_bracket, 1) {
      set_depth += 1; in_set = true
      set_type  = set_depth > 1 ? :subset : :set

      emit(set_type, :open, *text(data, ts, te))
      fcall character_set;
    };

    class_posix >(open_bracket, 1) @eof(premature_end_error) {
      text = text(data, ts, te).first

      class_name = text[2..-3]
      if class_name[0].chr == '^'
        class_name = "non#{class_name[1..-1]}"
      end

      token_sym = "class_#{class_name}".to_sym
      emit(set_type, token_sym, text, ts, te)
    };

    collating_sequence >(open_bracket, 1) @eof(premature_end_error) {
      emit(set_type, :collation, *text(data, ts, te))
    };

    character_equivalent >(open_bracket, 1) @eof(premature_end_error) {
      emit(set_type, :equivalent, *text(data, ts, te))
    };

    # exclude the closing bracket as a cleaner workaround for dealing with the
    # ambiguity caused upon exit from the unicode properties machine
    meta_char -- ']' {
      emit(set_type, :member, *text(data, ts, te))
    };

    any            |
    ascii_nonprint |
    utf8_2_byte    |
    utf8_3_byte    |
    utf8_4_byte    {
      emit(set_type, :member, *text(data, ts, te))
    };
  *|;

  # set escapes scanner
  # --------------------------------------------------------------------------
  set_escape_sequence := |*
    'b' > (escaped_set_alpha, 2) {
      emit(set_type, :backspace, *text(data, ts, te, 1))
      fret;
    };

    char_type > (escaped_set_alpha, 4) {
      case text = text(data, ts, te, 1).first
      when '\d'; emit(set_type, :type_digit,     text, ts-1, te)
      when '\D'; emit(set_type, :type_nondigit,  text, ts-1, te)
      when '\h'; emit(set_type, :type_hex,       text, ts-1, te)
      when '\H'; emit(set_type, :type_nonhex,    text, ts-1, te)
      when '\s'; emit(set_type, :type_space,     text, ts-1, te)
      when '\S'; emit(set_type, :type_nonspace,  text, ts-1, te)
      when '\w'; emit(set_type, :type_word,      text, ts-1, te)
      when '\W'; emit(set_type, :type_nonword,   text, ts-1, te)
      end
      fret;
    };

    hex_sequence . '-\\' . hex_sequence {
      emit(set_type, :range_hex, *text(data, ts, te, 1))
      fret;
    };

    hex_sequence {
      emit(set_type, :member_hex, *text(data, ts, te, 1))
      fret;
    };

    meta_char | [\\\]\-\,] {
      emit(set_type, :escape, *text(data, ts, te, 1))
      fret;
    };

    property_char > (escaped_set_alpha, 3) {
      fhold;
      fnext character_set;
      fcall unicode_property;
    };

    # special case exclusion of escaped dash, could be cleaner.
    (ascii_print - char_type -- [\-}]) > (escaped_set_alpha, 1) |
    ascii_nonprint            |
    utf8_2_byte               |
    utf8_3_byte               |
    utf8_4_byte               {
      emit(set_type, :escape, *text(data, ts, te, 1))
      fret;
    };
  *|;


  # escape sequence scanner
  # --------------------------------------------------------------------------
  escape_sequence := |*
    [1-9] {
      text = text(data, ts, te, 1).first
      emit(:backref, :number, text, ts-1, te)
      fret;
    };

    octal_sequence {
      emit(:escape, :octal, *text(data, ts, te, 1))
      fret;
    };

    meta_char {
      case text = text(data, ts, te, 1).first
      when '\.';  emit(:escape, :dot,               text, ts-1, te)
      when '\|';  emit(:escape, :alternation,       text, ts-1, te)
      when '\^';  emit(:escape, :bol,               text, ts-1, te)
      when '\$';  emit(:escape, :eol,               text, ts-1, te)
      when '\?';  emit(:escape, :zero_or_one,       text, ts-1, te)
      when '\*';  emit(:escape, :zero_or_more,      text, ts-1, te)
      when '\+';  emit(:escape, :one_or_more,       text, ts-1, te)
      when '\(';  emit(:escape, :group_open,        text, ts-1, te)
      when '\)';  emit(:escape, :group_close,       text, ts-1, te)
      when '\{';  emit(:escape, :interval_open,     text, ts-1, te)
      when '\}';  emit(:escape, :interval_close,    text, ts-1, te)
      when '\[';  emit(:escape, :set_open,          text, ts-1, te)
      when '\]';  emit(:escape, :set_close,         text, ts-1, te)
      when "\\\\";
        emit(:escape, :backslash, text, ts-1, te)
      end
      fret;
    };

    escaped_ascii > (escaped_alpha, 7) {
      # \b is emitted as backspace only when inside a character set, otherwise
      # it is a word boundary anchor. A syntax might "normalize" it if needed.
      case text = text(data, ts, te, 1).first
      when '\a'; emit(:escape, :bell,           text, ts-1, te)
      when '\e'; emit(:escape, :escape,         text, ts-1, te)
      when '\f'; emit(:escape, :form_feed,      text, ts-1, te)
      when '\n'; emit(:escape, :newline,        text, ts-1, te)
      when '\r'; emit(:escape, :carriage,       text, ts-1, te)
      when '\s'; emit(:escape, :space,          text, ts-1, te)
      when '\t'; emit(:escape, :tab,            text, ts-1, te)
      when '\v'; emit(:escape, :vertical_tab,   text, ts-1, te)
      end
      fret;
    };

    codepoint_sequence > (escaped_alpha, 6) $eof(premature_end_error) {
      text = text(data, ts, te, 1).first
      if text[2].chr == '{'
        emit(:escape, :codepoint_list, text, ts-1, te)
      else
        emit(:escape, :codepoint,      text, ts-1, te)
      end
      fret;
    };

    hex_sequence > (escaped_alpha, 5) $eof(premature_end_error) {
      emit(:escape, :hex, *text(data, ts, te, 1))
      fret;
    };

    wide_hex_sequence > (escaped_alpha, 5) $eof(premature_end_error) {
      emit(:escape, :hex_wide, *text(data, ts, te, 1))
      fret;
    };

    hex_sequence_err @invalid_sequence_error {
      fret;
    };

    (wide_hex_seq_invalid | wide_hex_seq_empty) {
      raise InvalidSequenceError.new("wide hex sequence")
      fret;
    };

    control_sequence >(escaped_alpha, 4) $eof(premature_end_error) {
      if data[te]
        c = data[te].chr
        if c =~ /[\x00-\x7F]/
          emit(:escape, :control, copy(data, ts-1..te), ts-1, te+1)
          p += 1
        else
          raise InvalidSequenceError.new("control sequence")
        end
      else
        raise PrematureEndError.new("control sequence")
      end
      fret;
    };

    meta_sequence >(backslashed, 3) $eof(premature_end_error) {
      if data[te]
        c = data[te].chr
        if c =~ /[\x00-\x7F]/
          emit(:escape, :meta_sequence, copy(data, ts-1..te), ts-1, te+1)
          p += 1
        else
          raise InvalidSequenceError.new("meta sequence")
        end
      else
        raise PrematureEndError.new("meta sequence")
      end
      fret;
    };

    property_char > (escaped_alpha, 2) {
      fhold;
      fnext main;
      fcall unicode_property;
    };

    (any -- non_literal_escape) > (escaped_alpha, 1)  {
      emit(:escape, :literal, *text(data, ts, te, 1))
      fret;
    };
  *|;


  # conditional expressions scanner
  # --------------------------------------------------------------------------
  conditional_expression := |*
    group_lookup . ')' {
      text = text(data, ts, te-1).first
      emit(:conditional, :condition, text, ts, te-1)
      emit(:conditional, :condition_close, ')', te-1, te)
    };

    any {
      fhold;
      fcall main;
    };
  *|;


  # Main scanner
  # --------------------------------------------------------------------------
  main := |*

    # Meta characters
    # ------------------------------------------------------------------------
    dot {
      emit(:meta, :dot, *text(data, ts, te))
    };

    alternation {
      if in_conditional and conditional_stack.length > 0 and 
         conditional_stack.last[1] == @group_depth
        emit(:conditional, :separator, *text(data, ts, te))
      else
        emit(:meta, :alternation, *text(data, ts, te))
      end
    };

    # Anchors
    # ------------------------------------------------------------------------
    beginning_of_line {
      emit(:anchor, :bol, *text(data, ts, te))
    };

    end_of_line {
      emit(:anchor, :eol, *text(data, ts, te))
    };

    backslash . 'K' > (backslashed, 4) {
      emit(:keep, :mark, *text(data, ts, te))
    };

    backslash . anchor_char > (backslashed, 3) {
      case text = text(data, ts, te).first
      when '\\A'; emit(:anchor, :bos,                text, ts, te)
      when '\\z'; emit(:anchor, :eos,                text, ts, te)
      when '\\Z'; emit(:anchor, :eos_ob_eol,         text, ts, te)
      when '\\b'; emit(:anchor, :word_boundary,      text, ts, te)
      when '\\B'; emit(:anchor, :nonword_boundary,   text, ts, te)
      when '\\G'; emit(:anchor, :match_start,        text, ts, te)
      else
        raise ScannerError.new(
          "Unexpected character in anchor at #{text} (char #{ts})")
      end
    };

    # Character types
    #   \d, \D    digit, non-digit
    #   \h, \H    hex, non-hex
    #   \s, \S    space, non-space
    #   \w, \W    word, non-word
    # ------------------------------------------------------------------------
    backslash . char_type > (backslashed, 2) {
      case text = text(data, ts, te).first
      when '\\d'; emit(:type, :digit,      text, ts, te)
      when '\\D'; emit(:type, :nondigit,   text, ts, te)
      when '\\h'; emit(:type, :hex,        text, ts, te)
      when '\\H'; emit(:type, :nonhex,     text, ts, te)
      when '\\s'; emit(:type, :space,      text, ts, te)
      when '\\S'; emit(:type, :nonspace,   text, ts, te)
      when '\\w'; emit(:type, :word,       text, ts, te)
      when '\\W'; emit(:type, :nonword,    text, ts, te)
      else
        raise ScannerError.new(
          "Unexpected character in type at #{text} (char #{ts})")
      end
    };


    # Character sets
    # ------------------------------------------------------------------------
    set_open {
      set_depth += 1; in_set = true
      set_type  = set_depth > 1 ? :subset : :set

      emit(set_type, :open, *text(data, ts, te))
      fcall character_set;
    };


    # Conditional expression
    #   (?(condition)Y|N)   conditional expression
    # ------------------------------------------------------------------------
    conditional {
      text = text(data, ts, te).first

      in_conditional = true unless in_conditional
      conditional_depth += 1
      conditional_stack << [conditional_depth, @group_depth]

      emit(:conditional, :open, text[0..-2], ts, te-1)
      emit(:conditional, :condition_open, '(', te-1, te)
      fcall conditional_expression;
    };


    # (?#...) comments: parsed as a single expression, without introducing a
    # new nesting level. Comments may not include parentheses, escaped or not.
    # special case for close, action performed on all transitions to get the 
    # correct closing count.
    # ------------------------------------------------------------------------
    group_open . group_comment $group_closed {
      emit(:group, :comment, *text(data, ts, te))
    };

    # Expression options:
    #   (?imxdau-imx)         option on/off
    #                         i: ignore case
    #                         m: multi-line (dot(.) match newline)
    #                         x: extended form
    #                         d: default class rules (1.9 compatible)
    #                         a: ASCII class rules (\s, \w, etc.)
    #                         u: Unicode class rules (\s, \w, etc.)
    #
    #   (?imxdau-imx:subexp)  option on/off for subexp
    # ------------------------------------------------------------------------
    group_open . group_options >group_opened {
      p = scan_options(p, data, ts, te)
    };

    # Assertions
    #   (?=subexp)          look-ahead
    #   (?!subexp)          negative look-ahead
    #   (?<=subexp)         look-behind
    #   (?<!subexp)         negative look-behind
    # ------------------------------------------------------------------------
    group_open . assertion_type >group_opened {
      case text = text(data, ts, te).first
      when '(?=';  emit(:assertion, :lookahead,    text, ts, te)
      when '(?!';  emit(:assertion, :nlookahead,   text, ts, te)
      when '(?<='; emit(:assertion, :lookbehind,   text, ts, te)
      when '(?<!'; emit(:assertion, :nlookbehind,  text, ts, te)
      end
    };

    # Groups
    #   (?:subexp)          passive (non-captured) group
    #   (?>subexp)          atomic group, don't backtrack in subexp.
    #   (?~subexp)          absence group, matches anything that is not subexp
    #   (?<name>subexp)     named group
    #   (?'name'subexp)     named group (single quoted version)
    #   (subexp)            captured group
    # ------------------------------------------------------------------------
    group_open . group_type >group_opened {
      case text = text(data, ts, te).first
      when '(?:';  emit(:group, :passive,      text, ts, te)
      when '(?>';  emit(:group, :atomic,       text, ts, te)
      when '(?~';  emit(:group, :absence,      text, ts, te)

      when /^\(\?<(\w*)>/
        empty_name_error(:group, 'named group (ab)') if $1.empty?

        emit(:group, :named_ab,  text, ts, te)

      when /^\(\?'(\w*)'/
        empty_name_error(:group, 'named group (sq)') if $1.empty?

        emit(:group, :named_sq,  text, ts, te)

      else
        raise ScannerError.new(
          "Unknown subexpression group format '#{text}'")
      end
    };

    group_open @group_opened {
      text = text(data, ts, te).first
      emit(:group, :capture, text, ts, te)
    };

    group_close @group_closed {
      if in_conditional and conditional_stack.last and
         conditional_stack.last[1] == (@group_depth + 1)

        emit(:conditional, :close, *text(data, ts, te))
        conditional_stack.pop

        if conditional_stack.length == 0
          in_conditional = false
        end
      else
        if @spacing_stack.length > 1 and
          @spacing_stack.last[1] == (@group_depth + 1)
          @spacing_stack.pop

          @free_spacing = @spacing_stack.last[0]

          if @spacing_stack.length == 1
            @in_options = false
          end
        end

        emit(:group, :close, *text(data, ts, te))
      end
    };


    # Group backreference, named and numbered
    # ------------------------------------------------------------------------
    backslash . (group_name_ref | group_number_ref) > (backslashed, 4) {
      case text = text(data, ts, te).first
      when /^\\([gk])<>/ # angle brackets
        empty_backref_error("ref/call (ab)")

      when /^\\([gk])''/ # single quotes
        empty_backref_error("ref/call (sq)")

      when /^\\([gk])<[^\d-](\w+)?>/ # angle-brackets
        if $1 == 'k'
          emit(:backref, :name_ref_ab,  text, ts, te)
        else
          emit(:backref, :name_call_ab,  text, ts, te)
        end

      when /^\\([gk])'[^\d-](\w+)?'/ #single quotes
        if $1 == 'k'
          emit(:backref, :name_ref_sq,  text, ts, te)
        else
          emit(:backref, :name_call_sq,  text, ts, te)
        end

      when /^\\([gk])<\d+>/ # angle-brackets
        if $1 == 'k'
          emit(:backref, :number_ref_ab,  text, ts, te)
        else
          emit(:backref, :number_call_ab,  text, ts, te)
        end

      when /^\\([gk])'\d+'/ # single quotes
        if $1 == 'k'
          emit(:backref, :number_ref_sq,  text, ts, te)
        else
          emit(:backref, :number_call_sq,  text, ts, te)
        end

      when /^\\([gk])<-\d+>/ # angle-brackets
        if $1 == 'k'
          emit(:backref, :number_rel_ref_ab,  text, ts, te)
        else
          emit(:backref, :number_rel_call_ab,  text, ts, te)
        end

      when /^\\([gk])'-\d+'/ # single quotes
        if $1 == 'k'
          emit(:backref, :number_rel_ref_sq,  text, ts, te)
        else
          emit(:backref, :number_rel_call_sq,  text, ts, te)
        end

      when /^\\k<[^\d-](\w+)?[+\-]\d+>/ # angle-brackets
        emit(:backref, :name_nest_ref_ab,  text, ts, te)

      when /^\\k'[^\d-](\w+)?[+\-]\d+'/ # single-quotes
        emit(:backref, :name_nest_ref_sq,  text, ts, te)

      when /^\\([gk])<\d+[+\-]\d+>/ # angle-brackets
        emit(:backref, :number_nest_ref_ab,  text, ts, te)

      when /^\\([gk])'\d+[+\-]\d+'/ # single-quotes
        emit(:backref, :number_nest_ref_sq,  text, ts, te)

      else
        raise ScannerError.new(
          "Unknown backreference format '#{text}'")
      end
    };


    # Quantifiers
    # ------------------------------------------------------------------------
    zero_or_one {
      case text = text(data, ts, te).first
      when '?' ;  emit(:quantifier, :zero_or_one,            text, ts, te)
      when '??';  emit(:quantifier, :zero_or_one_reluctant,  text, ts, te)
      when '?+';  emit(:quantifier, :zero_or_one_possessive, text, ts, te)
      end
    };

    zero_or_more {
      case text = text(data, ts, te).first
      when '*' ;  emit(:quantifier, :zero_or_more,            text, ts, te)
      when '*?';  emit(:quantifier, :zero_or_more_reluctant,  text, ts, te)
      when '*+';  emit(:quantifier, :zero_or_more_possessive, text, ts, te)
      end
    };

    one_or_more {
      case text = text(data, ts, te).first
      when '+' ;  emit(:quantifier, :one_or_more,            text, ts, te)
      when '+?';  emit(:quantifier, :one_or_more_reluctant,  text, ts, te)
      when '++';  emit(:quantifier, :one_or_more_possessive, text, ts, te)
      end
    };

    quantifier_interval  @err(premature_end_error) {
      emit(:quantifier, :interval, *text(data, ts, te))
    };

    # Escaped sequences
    # ------------------------------------------------------------------------
    backslash > (backslashed, 1) {
      fcall escape_sequence;
    };

    comment {
      if @free_spacing
        emit(:free_space, :comment, *text(data, ts, te))
      else
        append_literal(data, ts, te)
      end
    };

    space+ {
      if @free_spacing
        emit(:free_space, :whitespace, *text(data, ts, te))
      else
        append_literal(data, ts, te)
      end
    };

    # Literal: any run of ASCII (pritable or non-printable), and/or UTF-8,
    # except meta characters.
    # ------------------------------------------------------------------------
    (ascii_print -- space)+    |
    ascii_nonprint+ |
    utf8_2_byte+    |
    utf8_3_byte+    |
    utf8_4_byte+    {
      append_literal(data, ts, te)
    };

  *|;
}%%

# THIS IS A GENERATED FILE, DO NOT EDIT DIRECTLY
# This file was generated from lib/regexp_parser/scanner/scanner.rl

module Regexp::Scanner
  %% write data;

  # General scanner error (catch all)
  class ScannerError < StandardError; end

  # Base for all scanner validation errors
  class ValidationError < StandardError
    def initialize(reason)
      super reason
    end
  end

  # Unexpected end of pattern
  class PrematureEndError < ScannerError
    def initialize(where = '')
      super "Premature end of pattern at #{where}"
    end
  end

  # Invalid sequence format. Used for escape sequences, mainly.
  class InvalidSequenceError < ValidationError
    def initialize(what = 'sequence', where = '')
      super "Invalid #{what} at #{where}"
    end
  end

  # Invalid group. Used for named groups.
  class InvalidGroupError < ValidationError
    def initialize(what, reason)
      super "Invalid #{what}, #{reason}."
    end
  end

  # Invalid groupOption. Used for inline options.
  class InvalidGroupOption < ValidationError
    def initialize(option, text)
      super "Invalid group option #{option} in #{text}"
    end
  end

  # Invalid back reference. Used for name a number refs/calls.
  class InvalidBackrefError < ValidationError
    def initialize(what, reason)
      super "Invalid back reference #{what}, #{reason}"
    end
  end

  # The property name was not recognized by the scanner.
  class UnknownUnicodePropertyError < ValidationError
    def initialize(name)
      super "Unknown unicode character property name #{name}"
    end
  end

  # Scans the given regular expression text, or Regexp object and collects the
  # emitted token into an array that gets returned at the end. If a block is
  # given, it gets called for each emitted token.
  #
  # This method may raise errors if a syntax error is encountered.
  # --------------------------------------------------------------------------
  def self.scan(input_object, &block)
    @literal, top, stack = nil, 0, []

    if input_object.is_a?(Regexp)
      input    = input_object.source
      @free_spacing  = (input_object.options & Regexp::EXTENDED != 0)
    else
      input   = input_object
      @free_spacing = false
    end


    data  = input.unpack("c*") if input.is_a?(String)
    eof   = data.length

    @tokens = []
    @block  = block_given? ? block : nil

    @in_group, @group_depth = false, 0
    @in_options, @spacing_stack = false, [[@free_spacing, 0]]

    in_set,   set_depth, set_type   = false, 0, :set
    in_conditional, conditional_depth, conditional_stack = false, 0, []

    %% write init;
    %% write exec;

    if cs == re_scanner_error
      text = ts ? copy(data, ts-1..-1) : data.pack('c*')
      raise ScannerError.new("Scan error at '#{text}'")
    end

    raise PrematureEndError.new("(missing group closing paranthesis) "+
          "[#{@in_group}:#{@group_depth}]") if @in_group
    raise PrematureEndError.new("(missing set closing bracket) "+
          "[#{in_set}:#{set_depth}]") if in_set

    # when the entire expression is a literal run
    emit_literal if @literal

    @tokens
  end

  private

  # Ragel's regex-based scan of the group options introduced a lot of
  # ambiguity, so we just ask it to find the beginning of what looks
  # like an options run and handle the rest in here.
  def self.scan_options(p, data, ts, te)
    text = text(data, ts, te).first

    options_char, options_length = true, 0

    # Copy while we have option characters. There is no maximum length,
    # as ruby allows things like '(?xxxxxxxxx-xxxxxxxxxxxxx:abc)'.
    negative_options = false
    while options_char
      if data[te + options_length]
        c = data[te + options_length].chr

        if c =~ /[-mixdau]/
          negative_options = true if c == '-'

          raise InvalidGroupOption.new(c, text) if negative_options and
            c =~ /[dau]/

          text << c ; p += 1 ; options_length += 1
        else
          options_char = false
        end
      else
        raise PrematureEndError.new("expression options `#{text}'")
      end
    end

    if data[te + options_length]
      c = data[te + options_length].chr

      if c == ':'
        # Include the ':' in the options text
        text << c ; p += 1 ; options_length += 1
        emit_options(text, ts, te + options_length)

      elsif c == ')'
        # Don't include the closing ')', let group_close handle it.
        emit_options(text, ts, te + options_length)

      else
        # Plain Regexp reports this as 'undefined group option'
        raise ScannerError.new(
          "Unexpected `#{c}' in options sequence, ':' or ')' expected")
      end
    else
      raise PrematureEndError.new("expression options `#{text}'")
    end

    p # return the new value of the data pointer
  end

  # Copy from ts to te from data as text
  def self.copy(data, range)
    data[range].pack('c*')
  end

  # Copy from ts to te from data as text, returning an array with the text
  #  and the offsets used to copy it.
  def self.text(data, ts, te, soff = 0)
    [copy(data, ts-soff..te-1), ts-soff, te]
  end

  # Appends one or more characters to the literal buffer, to be emitted later
  # by a call to emit_literal. Contents can be a mix of ASCII and UTF-8.
  def self.append_literal(data, ts, te)
    @literal ||= []
    @literal << text(data, ts, te)
  end

  # Emits the literal run collected by calls to the append_literal method,
  # using the total start (ts) and end (te) offsets of the run.
  def self.emit_literal
    ts, te = @literal.first[1], @literal.last[2]
    text = @literal.map {|t| t[0]}.join

    text.force_encoding('utf-8') if text.respond_to?(:force_encoding)

    @literal = nil
    emit(:literal, :literal, text, ts, te)
  end

  def self.emit_options(text, ts, te)
    if text =~ /\(\?([mixdau]+)?-?([mix]+)?:/
      positive, negative = $1, $2

      if positive =~ /x/
        @free_spacing = true
      end

      # If the x appears in both, treat it like ruby does, the second cancels
      # the first.
      if negative =~ /x/
        @free_spacing = false
      end
    end

    @in_options = true
    @spacing_stack << [@free_spacing, @group_depth]

    emit(:group, :options, text, ts, te)
  end

  # Emits an array with the details of the scanned pattern
  def self.emit(type, token, text, ts, te)
    #puts "EMIT: type: #{type}, token: #{token}, text: #{text}, ts: #{ts}, te: #{te}"

    emit_literal if @literal

    if @block
      @block.call type, token, text, ts, te
    end

    @tokens << [type, token, text, ts, te]
  end

  # Centralizes and unifies the handling of validation related
  # errors.
  def self.validation_error(type, what, reason)
    case type
    when :group
      error = InvalidGroupError.new(what, reason)
    when :backref
      error = InvalidBackrefError.new(what, reason)
    when :sequence
      error = InvalidSequenceError.new(what, reason)
    else
      error = ValidationError.new('expression')
    end

    raise error # unless @@config.validation_ignore
  end

  # Used for references with an empty name or number
  def self.empty_backref_error(type, what)
    validation_error(:backref, what, 'ref ID is empty')
  end

  # Used for named expressions with an empty name
  def self.empty_name_error(type, what)
    validation_error(type, what, 'name is empty')
  end

end # module Regexp::Scanner
