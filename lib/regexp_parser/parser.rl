%%{
  machine re;

  wild                  = '.';
  backslash             = '\\';

  range_open            = '{';
  range_close           = '}';
  curlies               = range_open | range_close;

  group_open            = '(';
  group_close           = ')';
  parantheses           = group_open | group_close;

  set_open              = '[';
  set_close             = ']';
  brackets              = set_open | set_close;

  char_type             = [dDhHsSwW];

  line_anchor           = '^' | '$';
  anchor_char           = [AbBzZG];
  property_char         = [pP];

  escaped_char          = [aefnrtv]; # TODO: add b in sets
  octal_sequence        = '0' . [0-7]{2};

  hex_sequence          = 'x' . xdigit{2};
  wide_hex_sequence     = 'x' . '{7' . xdigit{1,7} . '}';

  control_sequence      = ('c' | 'C-') . xdigit{2};
  meta_sequence         = 'M-' . xdigit{2};

  zero_or_one           = '?' | '??' | '?+';
  zero_or_more          = '*' | '*?' | '*+';
  one_or_more           = '+' | '+?' | '++';

  quantifier_basic      = '?'  | '*'  | '+';
  quantifier_reluctant  = '??' | '*?' | '+?';
  quantifier_possessive = '?+' | '*+' | '++';
  quantifier_mode       = '?'  | '+';

  quantifier_range      = range_open . (digit+)? . ','? . (digit+)? . range_close . quantifier_mode?;

  quantifiers           = quantifier_basic | quantifier_reluctant |
                          quantifier_possessive | quantifier_range;


  group_comment         = '?#' . [^)]+ . group_close;

  group_atomic          = '?>';
  group_passive         = '?:';
  group_lookahead       = '?=';
  group_nlookahead      = '?!';
  group_lookbehind      = '?<=';
  group_nlookbehind     = '?<!';

  group_options         = '?' . [mix]+ . ('-' . [mix]+)? . ':'?;

  group_name            = alpha . alnum+;
  group_named           = '?<' . group_name . '>';

  group_type            = group_atomic | group_passive |
                          group_lookahead | group_nlookahead |
                          group_lookbehind | group_nlookbehind;

  # characters the 'break' a literal
  meta_char             = wild | backslash | curlies | parantheses | brackets |
                          line_anchor | quantifier_basic;

  main := |*
    # character types
    #   \d, \D    digit, non-digit
    #   \h, \H    hex, non-hex
    #   \s, \S    whitespace, non-whitespace
    #   \w, \W    word, non-word
    backslash . char_type > (backslashed, 2) {
      @root << Expression::CharacterType.new(data, ts, te)
    };

    # Anchors
    line_anchor {
      @root << Expression::Anchor.new(data, ts, te)
    };

    backslash . anchor_char > (backslashed, 2) {
      @root << Expression::Anchor.new(data, ts, te)
    };

    # escaped character
    backslash . any{1} > (backslashed, 1) {
      @root << Expression::Literal.new(data, ts, te)
    };

    # Character sets
    set_open . (any - meta_char)+ . set_close {
      @root << Expression::CharacterSet.new(data, ts, te)
    };

    # (?#...) comments: parsed as a single expression, without introducing a
    # new nesting level. Comments may not include parentheses, escaped or not.
    group_open . group_comment {
      @root << Expression::Comment.new(data, ts, te)
    };

    # Extended Groups
    #
    #   (subexp)            captured group
    #   (?imx-imx)          option on/off
    #                         i: ignore case
    #                         m: multi-line (dot(.) match newline)
    #                         x: extended form
    #
    #   (?imx-imx:subexp)   option on/off for subexp
    #   
    #   (?:subexp)          not captured group
    #   (?>subexp)          atomic group, don't backtrack in subexp.
    #   (?=subexp)          look-ahead
    #   (?!subexp)          negative look-ahead
    #   (?<=subexp)         look-behind
    #   (?<!subexp)         negative look-behind
    #   (?<name>subexp)     named group (single quotes are no supported, yet)
    # ------------------------------------------------------------------------
    group_open . group_type? {
      puts " *** GROUP: #{data[ts..te-1].pack('c*')}"
      puts " *** LENGTH: #{te - ts}"

      case data[ts..te-1].pack('c*')
      when '(?:';  exp = Expression::PassiveGroup.new(data, ts, te)
      when '(?>';  exp = Expression::Atomic.new(data, ts, te)
      when '(?=';  exp = Expression::Lookahead.new(data, ts, te)
      when '(?!';  exp = Expression::NegativeLookahead.new(data, ts, te)
      when '(?<='; exp = Expression::Lookbehind.new(data, ts, te)
      when '(?<!'; exp = Expression::NegativeLookbehind.new(data, ts, te)
      else         exp = Expression::Group.new(data, ts, te)
      end

      self.open_group exp
    };


    # (?<name>...) named capturing groups:
    group_open . group_named? {
      puts " *** NAMED-GROUP: #{data[ts..te-1].pack('c*')}"
      puts " *** LENGTH: #{te - ts}"

      self.open_group Expression::NamedGroup.new(data, ts, te)
    };

    # (?mix-mix...) expression options:
    group_open . group_options? {
      puts " *** OPTIONS: #{data[ts+2..te-1].pack('c*')}"
      puts " *** LENGTH: #{te - ts}"

      opt = data[ts+2..te-1].pack('c*').split('-', 2)

      exp = Expression::Options.new(data, ts, te)
      exp.options = {
        :m => opt[0].include?('m') ? true : false,
        :i => opt[0].include?('i') ? true : false,
        :x => opt[0].include?('x') ? true : false
      }

      self.open_group exp
    };

    # closing parenthesis, ends current nesting level
    group_close { self.close_group };


    # Quantifiers
    # ------------------------------------------------------------------------
    zero_or_one {
      mode = case data[ts..te-1].pack('c*')
      when '??'; :reluctant
      when '?+'; :possessive
      else :basic
      end

      @root.expressions.last.quantify(:zero_or_one,  0, 1, mode)
    };
  
    zero_or_more {
      mode = case data[ts..te-1].pack('c*')
      when '*?'; :reluctant
      when '*+'; :possessive
      else :basic
      end

      @root.expressions.last.quantify(:zero_or_more,  0, -1, mode)
    };
  
    one_or_more {
      mode = case data[ts..te-1].pack('c*')
      when '+?'; :reluctant
      when '++'; :possessive
      else :basic
      end

      @root.expressions.last.quantify(:one_or_more,  1, -1, mode)
    };


    # Repetition: min, max, and exact notations
    # ------------------------------------------------------------------------
    range_open . (digit+)? . ','? . (digit+)? . range_close . quantifier_mode? {
      text = data[ts..te-1].pack('c*')

      mchr = text[text.length-1].chr =~ /[?+]/ ? text[text.length-1].chr : nil
      mode = case mchr
      when '?'; text.chop!; :reluctant
      when '+'; text.chop!; :possessive
      else :basic
      end

      range = text.gsub(/\{|\}/, '').split(',', 2).each {|i| i.strip}
      min = range[0].empty? ? 0 : range[0]
      max = range[1] ? (range[1].empty? ? -1 : range[1]) : min

      @root.expressions.last.quantify(:repetition, min.to_i, max.to_i, mode)
    };


    # Literal: anything, except meta characters. This includes 2, 3, and 4
    # unicode byte sequences.
    # ------------------------------------------------------------------------
    (any - meta_char)+ {
      @root << Expression::Literal.new(data, ts, te)
    };

  *|;

}%%

require File.expand_path('../expression', __FILE__)
require File.expand_path('../group', __FILE__)

class Regexp
  module Parser
    %% write data;

    def self.parse(input)
      top, stack = 0, []

      input = input.source if input.is_a?(Regexp) # FIXME: to_s
      data = input.unpack("c*") if input.is_a?(String)
      eof  = data.length

      @nesting = [@root = Expression::Root.new]

      %% write init;
      %% write exec;

      @root
    end

    def self.open_group(exp)
      @nesting.push exp

      @root << exp
      @root  = exp
    end

    def self.close_group
      last_group = @nesting.pop
      #puts " *** LAST: #{last_group.inspect}" 
      @root = @nesting.last
    end

  end # module Parser
end # class Regexp
