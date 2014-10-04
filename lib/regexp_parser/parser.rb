require File.expand_path('../expression', __FILE__)

module Regexp::Parser
  include Regexp::Expression
  include Regexp::Syntax

  class ParserError < StandardError
    def initialize(what)
      super what
    end
  end

  class UnknownTokenTypeError < ParserError
    def initialize(type, token)
      super "Unknown #{type} type #{token.inspect}"
    end
  end

  class UnknownTokenError < ParserError
    def initialize(type, token)
      super "Unknown #{type} token #{token.token}"
    end
  end

  def self.parse(input, syntax = "ruby/#{RUBY_VERSION}", &block)
    @nesting = [@root = @node = Root.new]

    Regexp::Lexer.scan(input, syntax) do |token|
      self.parse_token token
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

  def self.parse_token(token)
    case token.type
    when :meta;         self.meta(token)
    when :quantifier;   self.quantifier(token)
    when :anchor;       self.anchor(token)
    when :escape;       self.escape(token)
    when :group;        self.group(token)
    when :assertion;    self.group(token)
    when :set, :subset; self.set(token)
    when :type;         self.type(token)
    when :backref;      self.backref(token)

    when :property, :nonproperty
      self.property(token)

    when :literal
      @node << Literal.new(token)

    else
      raise UnknownTokenTypeError.new(token.type, token)
    end
  end

  def self.set(token)
    case token.token
    when :open
      self.open_set(token)
    when :close
      self.close_set(token)
    when :negate
      self.negate_set
    when :member, :range, :escape, :collation, :equivalent
      self.append_set(token)
    when *Token::Escape::All
      self.append_set(token)
    when *Token::CharacterSet::All
      self.append_set(token)
    when *Token::UnicodeProperty::All
      self.append_set(token)
    else
      raise UnknownTokenError.new('CharacterSet', token)
    end
  end

  def self.meta(token)
    case token.token
    when :dot
      @node << CharacterType::Any.new(token)
    when :alternation
      unless @node.token == :alternation
        unless @node.last.is_a?(Alternation)
          alt = Alternation.new(token)
          seq = Sequence.new

          while @node.expressions.last
            seq.insert @node.expressions.pop
          end
          alt.alternative(seq)

          @node << alt
          @node = alt
          @node.alternative
        else
          @node = @node.last
          @node.alternative
        end
      else
        @node.alternative
      end
    else
      raise UnknownTokenError.new('Meta', token)
    end
  end

  def self.backref(token)
    case token.token
    when :name_ref
      @node << Backreference::Name.new(token)
    when :name_nest_ref
      @node << Backreference::NameNestLevel.new(token)
    when :name_call
      @node << Backreference::NameCall.new(token)
    when :number, :number_ref
      @node << Backreference::Number.new(token)
    when :number_rel_ref
      @node << Backreference::NumberRelative.new(token)
    when :number_nest_ref
      @node << Backreference::NumberNestLevel.new(token)
    when :number_call
      @node << Backreference::NumberCall.new(token)
    when :number_rel_call
      @node << Backreference::NumberCallRelative.new(token)
    else
      raise UnknownTokenError.new('Backreference', token)
    end
  end

  def self.type(token)
    case token.token
    when :digit
      @node << CharacterType::Digit.new(token)
    when :nondigit
      @node << CharacterType::NonDigit.new(token)
    when :hex
      @node << CharacterType::Hex.new(token)
    when :nonhex
      @node << CharacterType::NonHex.new(token)
    when :space
      @node << CharacterType::Space.new(token)
    when :nonspace
      @node << CharacterType::NonSpace.new(token)
    when :word
      @node << CharacterType::Word.new(token)
    when :nonword
      @node << CharacterType::NonWord.new(token)
    else
      raise UnknownTokenError.new('CharacterType', token)
    end
  end

  def self.property(token)
    include Regexp::Expression::UnicodeProperty

    case token.token
    when :alnum;            @node << Alnum.new(token)
    when :alpha;            @node << Alpha.new(token)
    when :any;              @node << Any.new(token)
    when :ascii;            @node << Ascii.new(token)
    when :blank;            @node << Blank.new(token)
    when :cntrl;            @node << Cntrl.new(token)
    when :digit;            @node << Digit.new(token)
    when :graph;            @node << Graph.new(token)
    when :lower;            @node << Lower.new(token)
    when :print;            @node << Print.new(token)
    when :punct;            @node << Punct.new(token)
    when :space;            @node << Space.new(token)
    when :upper;            @node << Upper.new(token)
    when :word;             @node << Word.new(token)
    when :xdigit;           @node << Xdigit.new(token)
    when :newline;          @node << Newline.new(token)

    when :letter_any;       @node << Letter::Any.new(token)
    when :letter_uppercase; @node << Letter::Uppercase.new(token)
    when :letter_lowercase; @node << Letter::Lowercase.new(token)
    when :letter_titlecase; @node << Letter::Titlecase.new(token)
    when :letter_modifier;  @node << Letter::Modifier.new(token)
    when :letter_other;     @node << Letter::Other.new(token)

    when :mark_any;         @node << Mark::Any.new(token)
    when :mark_nonspacing;  @node << Mark::Nonspacing.new(token)
    when :mark_spacing;     @node << Mark::Spacing.new(token)
    when :mark_enclosing;   @node << Mark::Enclosing.new(token)

    when :number_any;       @node << Number::Any.new(token)
    when :number_decimal;   @node << Number::Decimal.new(token)
    when :number_letter;    @node << Number::Letter.new(token)
    when :number_other;     @node << Number::Other.new(token)

    when :punct_any;        @node << Punctuation::Any.new(token)
    when :punct_connector;  @node << Punctuation::Connector.new(token)
    when :punct_dash;       @node << Punctuation::Dash.new(token)
    when :punct_open;       @node << Punctuation::Open.new(token)
    when :punct_close;      @node << Punctuation::Close.new(token)
    when :punct_initial;    @node << Punctuation::Initial.new(token)
    when :punct_final;      @node << Punctuation::Final.new(token)
    when :punct_other;      @node << Punctuation::Other.new(token)

    when :separator_any;    @node << Separator::Any.new(token)
    when :separator_space;  @node << Separator::Space.new(token)
    when :separator_line;   @node << Separator::Line.new(token)
    when :separator_para;   @node << Separator::Paragraph.new(token)

    when :symbol_any;       @node << Symbol::Any.new(token)
    when :symbol_math;      @node << Symbol::Math.new(token)
    when :symbol_currency;  @node << Symbol::Currency.new(token)
    when :symbol_modifier;  @node << Symbol::Modifier.new(token)
    when :symbol_other;     @node << Symbol::Other.new(token)

    when :other;            @node << Codepoint::Any.new(token)
    when :control;          @node << Codepoint::Control.new(token)
    when :format;           @node << Codepoint::Format.new(token)
    when :surrogate;        @node << Codepoint::Surrogate.new(token)
    when :private_use;      @node << Codepoint::PrivateUse.new(token)
    when :unassigned;       @node << Codepoint::Unassigned.new(token)

    when *Token::UnicodeProperty::Age
      @node << Age.new(token)

    when *Token::UnicodeProperty::Derived
      @node << Derived.new(token)

    when *Regexp::Syntax::Token::UnicodeProperty::Script
      @node << Script.new(token)

    else
      raise UnknownTokenError.new('UnicodeProperty', token)
    end
  end

  def self.anchor(token)
    case token.token
    when :bol
      @node << Anchor::BeginningOfLine.new(token)
    when :eol
      @node << Anchor::EndOfLine.new(token)
    when :bos
      @node << Anchor::BOS.new(token)
    when :eos
      @node << Anchor::EOS.new(token)
    when :eos_ob_eol
      @node << Anchor::EOSobEOL.new(token)
    when :word_boundary
      @node << Anchor::WordBoundary.new(token)
    when :nonword_boundary
      @node << Anchor::NonWordBoundary.new(token)
    when :match_start
      @node << Anchor::MatchStart.new(token)
    else
      raise UnknownTokenError.new('Anchor', token)
    end
  end

  def self.escape(token)
    case token.token

    when :backspace
      @node << EscapeSequence::Backspace.new(token)

    when :escape
      @node << EscapeSequence::AsciiEscape.new(token)
    when :bell
      @node << EscapeSequence::Bell.new(token)
    when :form_feed
      @node << EscapeSequence::FormFeed.new(token)
    when :newline
      @node << EscapeSequence::Newline.new(token)
    when :carriage
      @node << EscapeSequence::Return.new(token)
    when :space
      @node << EscapeSequence::Space.new(token)
    when :tab
      @node << EscapeSequence::Tab.new(token)
    when :vertical_tab
      @node << EscapeSequence::VerticalTab.new(token)

    when :control
      @node << EscapeSequence::Control.new(token)

    else
      # treating everything else as a literal
      @node << EscapeSequence::Literal.new(token)
    end
  end

  def self.quantifier(token)
    unless @node.expressions.last
      if token.token == :zero_or_one
        raise "Quantifier given without a target, or the syntax of the group " +
              "or its options is incorrect"
      else
        raise "Quantifier `#{token.text}' given without a target"
      end
    end

    case token.token
    when :zero_or_one
      @node.expressions.last.quantify(:zero_or_one, token.text, 0, 1, :greedy)
    when :zero_or_one_reluctant
      @node.expressions.last.quantify(:zero_or_one, token.text, 0, 1, :reluctant)
    when :zero_or_one_possessive
      @node.expressions.last.quantify(:zero_or_one, token.text, 0, 1, :possessive)

    when :zero_or_more
      @node.expressions.last.quantify(:zero_or_more, token.text, 0, -1, :greedy)
    when :zero_or_more_reluctant
      @node.expressions.last.quantify(:zero_or_more, token.text, 0, -1, :reluctant)
    when :zero_or_more_possessive
      @node.expressions.last.quantify(:zero_or_more, token.text, 0, -1, :possessive)

    when :one_or_more
      @node.expressions.last.quantify(:one_or_more, token.text, 1, -1, :greedy)
    when :one_or_more_reluctant
      @node.expressions.last.quantify(:one_or_more, token.text, 1, -1, :reluctant)
    when :one_or_more_possessive
      @node.expressions.last.quantify(:one_or_more, token.text, 1, -1, :possessive)

    when :interval
      self.interval(token.text)

    else
      raise UnknownTokenError.new('Quantifier', token)
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

    @node.expressions.last.quantify(:interval, text, min.to_i, max.to_i, mode)
  end

  def self.group(token)
    case token.token
    when :options
      self.options(token)
    when :close
      self.close_group
    when :comment
      @node << Group::Comment.new(token)
    else
      self.open_group(token)
    end
  end

  def self.options(token)
    opt = token.text.split('-', 2)

    exp = Group::Options.new(token)
    exp.options = {
      :m => opt[0].include?('m') ? true : false,
      :i => opt[0].include?('i') ? true : false,
      :x => opt[0].include?('x') ? true : false
    }

    self.nest exp
  end

  def self.open_group(token)
    case token.token
    when :passive
      exp = Group::Passive.new(token)
    when :atomic
      exp = Group::Atomic.new(token)
    when :named
      exp = Group::Named.new(token)
    when :capture
      exp = Group::Capture.new(token)

    when :lookahead
      exp = Assertion::Lookahead.new(token)
    when :nlookahead
      exp = Assertion::NegativeLookahead.new(token)
    when :lookbehind
      exp = Assertion::Lookbehind.new(token)
    when :nlookbehind
      exp = Assertion::NegativeLookbehind.new(token)

    else
      raise UnknownTokenError.new('Group type open', token)
    end

    self.nest exp
  end

  def self.close_group
    @nesting.pop

    @node = @nesting.last
    @node = @node.last if @node.last and @node.last.is_a?(Alternation)
  end

  def self.open_set(token)
    token.token = :character

    if token.type == :subset
      @set << CharacterSubSet.new(token)
    else
      @node << (@set = CharacterSet.new(token))
    end
  end

  def self.negate_set
    @set.negate
  end

  def self.append_set(token)
    @set << token.text
  end

  def self.close_set(token)
    @set.close
  end

end # module Regexp::Parser
