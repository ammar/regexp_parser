%%{
  machine re_simple;
  include re_scanner "scanner.rl";
}%%

require File.expand_path('../expression', __FILE__)

module Regexp::Parser
  include Expression

  %% write data;

  def self.parse(input)
    top, stack = 0, []

    input = input.to_s if input.is_a?(Regexp)
    #puts "INPUT: #{input.inspect}"

    data = input.unpack("c*") if input.is_a?(String)
    eof  = data.length

    @root = @node = Expression::Root.new
    @nesting = [@node]

    %% write init;
    %% write exec;

    @root
  end

  def self.nest(exp)
    @nesting.push exp

    @node << exp
    @node  = exp
  end

  def self.emit(type, token, text, ts, te)
    #puts "[#{type.inspect}, #{token.inspect}] #{text}"
    case type
    when :literal
      @node << Expression::Literal.new(type, token, text)
    when :quantifier
        self.quantifier(type, token, text)
    when :group
      self.group(type, token, text)
    when :character_set
      self.character_set(type, token, text)
    when :character_type
      self.character_type(type, token, text)
    when :property, :inverted_property
      self.character_property(type, token, text)
    when :anchor
      self.anchor(type, token, text)
    when :escape_sequence
      self.escape_sequence(type, token, text)

    else
      raise "EMIT: unexpected token type #{type.inspect}, #{token.inspect} #{text}"
    end
  end

  def self.character_set(type, token, text)
    case token
    when :open
      self.open_set(type, token, text)
    when :negate
      self.negate_set
    when :member
      self.append_set(type, token, text)
    when :range
      self.append_set(type, token, text)
    when :close
      self.close_set
    end
  end

  def self.character_type(type, token, text)
    case token
    when :any
      @node << Expression::CharacterType::Any.new(type, token, text)
    when :digit
      @node << Expression::CharacterType::Digit.new(type, token, text)
    when :non_digit
      @node << Expression::CharacterType::NonDigit.new(type, token, text)
    when :hex
      @node << Expression::CharacterType::Hex.new(type, token, text)
    when :non_hex
      @node << Expression::CharacterType::NonHex.new(type, token, text)
    when :space
      @node << Expression::CharacterType::Space.new(type, token, text)
    when :non_space
      @node << Expression::CharacterType::NonSpace.new(type, token, text)
    when :word
      @node << Expression::CharacterType::Word.new(type, token, text)
    when :non_word
      @node << Expression::CharacterType::NonWord.new(type, token, text)
    end
  end

  def self.character_property(type, token, text)
    case token
    when :alnum;  @node << CharacterProperty::Alnum.new(type, token, text)
    when :alpha;  @node << CharacterProperty::Alpha.new(type, token, text)
    when :any;    @node << CharacterProperty::Any.new(type, token, text)
    when :ascii;  @node << CharacterProperty::Ascii.new(type, token, text)
    when :blank;  @node << CharacterProperty::Blank.new(type, token, text)
    when :cntrl;  @node << CharacterProperty::Cntrl.new(type, token, text)
    when :digit;  @node << CharacterProperty::Digit.new(type, token, text)
    when :graph;  @node << CharacterProperty::Graph.new(type, token, text)
    when :lower;  @node << CharacterProperty::Lower.new(type, token, text)
    when :print;  @node << CharacterProperty::Print.new(type, token, text)
    when :punct;  @node << CharacterProperty::Punct.new(type, token, text)
    when :space;  @node << CharacterProperty::Space.new(type, token, text)
    when :upper;  @node << CharacterProperty::Upper.new(type, token, text)
    when :word;   @node << CharacterProperty::Word.new(type, token, text)
    when :xdigit; @node << CharacterProperty::Xdigit.new(type, token, text)
    end
  end

  # Lu  Uppercase_Letter  Uppercase letter
  # Ll  Lowercase_Letter  Lowercase letter
  # Lt  Titlecase_Letter  Digraphic character, with first part uppercase
  # Lm  Modifier_Letter Modifier letter
  # Lo  Other_Letter  Remaining letters, e.g. syllables and ideographs
  # Mn  Nonspacing_Mark Non-spacing combining mark (zero advance width)
  # Mc  Spacing_Mark  Spacing, combining mark (positive advance width)
  # Me  Enclosing_Mark  Enclosing combining mark
  # Nd  Decimal_Number  Decimal digit
  # Nl  Letter_Number Letter-like numeric character
  # No  Other_Number  Another type of numeric character
  # Pc  Connector_Punctuation Connecting punctuation mark
  # Pd  Dash_Punctuation  Dash or hyphen punctuation mark
  # Ps  Open_Punctuation  Opening punctuation mark (of a pair)
  # Pe  Close_Punctuation Closing punctuation mark (of a pair)
  # Pi  Initial_Punctuation Initial quotation mark
  # Pf  Final_Punctuation Final quotation mark
  # Po  Other_Punctuation Another type of punctuation mark
  # Sm  Math_Symbol Mathematical symbol
  # Sc  Currency_Symbol Currency sign
  # Sk  Modifier_Symbol Non-letter-like modifier symbol
  # So  Other_Symbol  Another type of symbol
  # Zs  Space_Separator Space character (of non-zero width)
  # Zl  Line_Separator  Line separator (U＋2028)
  # Zp  Paragraph_Separator Paragraph separator (U＋2029)
  # Cc  Control A C0 or C1 control code
  # Cf  Format  Format control character
  # Cs  Surrogate Surrogate code point
  # Co  Private_Use Private-use character
  # Cn  Unassigned  Reserved, unassigned code point or a non-character codepoint

  def self.anchor(type, token, text)
    case token
    when :beginning_of_line
      @node << Expression::Anchor::BeginningOfLine.new(type, token, text)
    when :end_of_line
      @node << Expression::Anchor::EndOfLine.new(type, token, text)
    when :bos
      @node << Expression::Anchor::BOS.new(type, token, text)
    when :eos
      @node << Expression::Anchor::EOS.new(type, token, text)
    when :eos_or_before_eol
      @node << Expression::Anchor::EOSOrBeforeEOL.new(type, token, text)
    when :word_boundary
      @node << Expression::Anchor::WordBoundary.new(type, token, text)
    when :non_word_boundary
      @node << Expression::Anchor::NonWordBoundary.new(type, token, text)
    end
  end

  def self.escape_sequence(type, token, text)
    case token
    when :control
      @node << Expression::EscapeSequence::Control.new(type, token, text)
    when :literal
      @node << Expression::EscapeSequence::Literal.new(type, token, text)
    end
  end

  def self.quantifier(type, token, text)
    case token
    when :zero_or_one
      @node.expressions.last.quantify(:zero_or_one, 0, 1, :greedy)
    when :zero_or_one_reluctant
      @node.expressions.last.quantify(:zero_or_one, 0, 1, :reluctant)
    when :zero_or_one_possessive
      @node.expressions.last.quantify(:zero_or_one, 0, 1, :possessive)

    when :zero_or_more
      @node.expressions.last.quantify(:zero_or_more, 0, -1, :greedy)
    when :zero_or_more_reluctant
      @node.expressions.last.quantify(:zero_or_more, 0, -1, :reluctant)
    when :zero_or_more_possessive
      @node.expressions.last.quantify(:zero_or_more, 0, -1, :possessive)

    when :one_or_more
      @node.expressions.last.quantify(:one_or_more, 1, -1, :greedy)
    when :one_or_more_reluctant
      @node.expressions.last.quantify(:one_or_more, 1, -1, :reluctant)
    when :one_or_more_possessive
      @node.expressions.last.quantify(:one_or_more, 1, -1, :possessive)

    when :interval
      self.interval(text)
    end
  end

  def self.interval(text)
    mchr = text[text.length-1].chr =~ /[?+]/ ? text[text.length-1].chr : nil
    mode = case mchr
    when '?'; text.chop!; :reluctant
    when '+'; text.chop!; :possessive
    else :greedy
    end

    range = text.gsub(/\{|\}/, '').split(',', 2).each {|i| i.strip}
    min = range[0].empty? ? 0 : range[0]
    max = range[1] ? (range[1].empty? ? -1 : range[1]) : min

    @node.expressions.last.quantify(:interval, min.to_i, max.to_i, mode)
  end

  def self.group(type, token, text)
    case token
    when :options
      self.options(type, token, text)
    when :close
      self.close_group
    when :comment
      @node << Expression::Group::Comment.new(type, token, text)
    else
      self.open_group(type, token, text)
    end
  end

  def self.options(type, token, text)
    opt = text.split('-', 2)

    exp = Expression::Group::Options.new(type, token, text)
    exp.options = {
      :m => opt[0].include?('m') ? true : false,
      :i => opt[0].include?('i') ? true : false,
      :x => opt[0].include?('x') ? true : false
    }

    self.nest exp
  end

  def self.open_group(type, token, text)
    case token
    when :passive
      exp = Expression::Group::Passive.new(type, token, text)
    when :atomic
      exp = Expression::Group::Atomic.new(type, token, text)
    when :lookahead
      exp = Expression::Group::Lookahead.new(type, token, text)
    when :nlookahead
      exp = Expression::Group::NegativeLookahead.new(type, token, text)
    when :lookbehind
      exp = Expression::Group::Lookbehind.new(type, token, text)
    when :nlookbehind
      exp = Expression::Group::NegativeLookbehind.new(type, token, text)
    when :named
      exp = Expression::Group::Named.new(type, token, text)
    when :capture
      exp = Expression::Group::Capture.new(type, token, text)
    else
      raise "unexpected #{type.inspect}, #{token.inspect} #{text}"
    end

    self.nest exp
  end

  def self.close_group
    last_group = @nesting.pop
    @node = @nesting.last
  end

  def self.open_set(type, token, text)
    @node << (@set = Expression::CharacterSet.new(type, token, text))
  end

  def self.negate_set
    @set.negate
  end

  def self.append_set(type, token, text)
    @set << text
  end

  def self.close_set
  end

end # module Regexp::Parser
