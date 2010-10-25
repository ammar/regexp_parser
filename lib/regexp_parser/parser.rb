require File.expand_path('../expression', __FILE__)

module Regexp::Parser
  include Expression

  def self.parse(input, syntax = :any, &block)
    @nesting = [@root = @node = Expression::Root.new]

    Regexp::Lexer.scan(input, syntax) do |token|
      self.parse_token( *token.to_a[0,5] )
    end

    if block_given?
      block.call @root
    else
      @root
    end
  end

  def self.nest(exp)
    @nesting.push exp

    @node << exp
    @node  = exp
  end

  def self.parse_token(type, token, text, ts, te)
    #puts "[#{type.inspect}, #{token.inspect}] #{text}"
    case type
    when :meta;         self.meta(type, token, text)
    when :quantifier;   self.quantifier(type, token, text)
    when :anchor;       self.anchor(type, token, text)
    when :escape;       self.escape(type, token, text)
    when :group;        self.group(type, token, text)
    when :set;          self.set(type, token, text)
    when :type;         self.type(type, token, text)

    when :property, :inverted_property
      self.property(type, token, text)

    when :literal
      @node << Expression::Literal.new(type, token, text)

    else
      raise "EMIT: unexpected token type #{type.inspect}, #{token.inspect} #{text}"
    end
  end

  def self.set(type, token, text)
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

  def self.meta(type, token, text)
    case token
    when :alternation
      unless @node.token == :alternation
        alt = Expression::Alternation.new(type, token, text)

        alt << @node.expressions.pop
        @node << alt
        @node = alt
      end
    end
  end

  def self.type(type, token, text)
    case token
    when :any
      @node << Expression::CharacterType::Any.new(type, token, text)
    when :digit
      @node << Expression::CharacterType::Digit.new(type, token, text)
    when :nondigit
      @node << Expression::CharacterType::NonDigit.new(type, token, text)
    when :hex
      @node << Expression::CharacterType::Hex.new(type, token, text)
    when :nonhex
      @node << Expression::CharacterType::NonHex.new(type, token, text)
    when :space
      @node << Expression::CharacterType::Space.new(type, token, text)
    when :nonspace
      @node << Expression::CharacterType::NonSpace.new(type, token, text)
    when :word
      @node << Expression::CharacterType::Word.new(type, token, text)
    when :nonword
      @node << Expression::CharacterType::NonWord.new(type, token, text)
    end
  end

  def self.property(type, token, text)
    #puts "type: #{type.inspect}, token: #{token.inspect}, text: #{text.inspect}"

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


    when :letter_any;       @node << CharacterProperty::Letter::Any.new(type, token, text)
    when :letter_uppercase; @node << CharacterProperty::Letter::Uppercase.new(type, token, text)
    when :letter_lowercase; @node << CharacterProperty::Letter::Lowercase.new(type, token, text)
    when :letter_titlecase; @node << CharacterProperty::Letter::Titlecase.new(type, token, text)
    when :letter_modifier;  @node << CharacterProperty::Letter::Modifier.new(type, token, text)
    when :letter_other;     @node << CharacterProperty::Letter::Other.new(type, token, text)

    when :mark_any;         @node << CharacterProperty::Mark::Any.new(type, token, text)
    when :mark_nonspacing;  @node << CharacterProperty::Mark::Nonspacing.new(type, token, text)
    when :mark_spacing;     @node << CharacterProperty::Mark::Spacing.new(type, token, text)
    when :mark_enclosing;   @node << CharacterProperty::Mark::Enclosing.new(type, token, text)

    when :number_any;       @node << CharacterProperty::Number::Any.new(type, token, text)
    when :number_decimal;   @node << CharacterProperty::Number::Decimal.new(type, token, text)
    when :number_letter;    @node << CharacterProperty::Number::Letter.new(type, token, text)
    when :number_other;     @node << CharacterProperty::Number::Other.new(type, token, text)

    when :punct_any;        @node << CharacterProperty::Punctuation::Any.new(type, token, text)
    when :punct_connector;  @node << CharacterProperty::Punctuation::Connector.new(type, token, text)
    when :punct_dash;       @node << CharacterProperty::Punctuation::Dash.new(type, token, text)
    when :punct_open;       @node << CharacterProperty::Punctuation::Open.new(type, token, text)
    when :punct_close;      @node << CharacterProperty::Punctuation::Close.new(type, token, text)
    when :punct_initial;    @node << CharacterProperty::Punctuation::Initial.new(type, token, text)
    when :punct_final;      @node << CharacterProperty::Punctuation::Final.new(type, token, text)
    when :punct_other;      @node << CharacterProperty::Punctuation::Other.new(type, token, text)

    when :separator_any;    @node << CharacterProperty::Separator::Any.new(type, token, text)
    when :separator_space;  @node << CharacterProperty::Separator::Space.new(type, token, text)
    when :separator_line;   @node << CharacterProperty::Separator::Line.new(type, token, text)
    when :separator_paragraph; @node << CharacterProperty::Separator::Paragraph.new(type, token, text)

    when :symbol_any;       @node << CharacterProperty::Symbol::Any.new(type, token, text)
    when :symbol_math;      @node << CharacterProperty::Symbol::Math.new(type, token, text)
    when :symbol_currency;  @node << CharacterProperty::Symbol::Currency.new(type, token, text)
    when :symbol_modifier;  @node << CharacterProperty::Symbol::Modifier.new(type, token, text)
    when :symbol_other;     @node << CharacterProperty::Symbol::Other.new(type, token, text)

    when :codepoint_any;        @node << CharacterProperty::Codepoint::Any.new(type, token, text)
    when :codepoint_control;    @node << CharacterProperty::Codepoint::Control.new(type, token, text)
    when :codepoint_format;     @node << CharacterProperty::Codepoint::Format.new(type, token, text)
    when :codepoint_surrogate;  @node << CharacterProperty::Codepoint::Surrogate.new(type, token, text)
    when :codepoint_private;    @node << CharacterProperty::Codepoint::PrivateUse.new(type, token, text)
    when :codepoint_unassigned; @node << CharacterProperty::Codepoint::Unassigned.new(type, token, text)
    end
  end

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
    when :nonword_boundary
      @node << Expression::Anchor::NonWordBoundary.new(type, token, text)
    end
  end

  def self.escape(type, token, text)
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
