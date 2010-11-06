require File.expand_path('../expression', __FILE__)

module Regexp::Parser
  include Regexp::Expression
  include Regexp::Syntax

  def self.parse(input, syntax = :any, &block)
    @nesting = [@root = @node = Root.new]

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

    when :property, :nonproperty
      self.property(type, token, text)

    when :literal
      @node << Literal.new(type, token, text)

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
    when :member, :escape
      self.append_set(type, token, text)
    when :range
      self.append_set(type, token, text)
    when *Token::CharacterSet::POSIX::All
      self.append_set(type, token, text)
    when :close
      self.close_set
    else
      raise "Unsupported CharacterSet token #{token.inspect}"
    end
  end

  def self.meta(type, token, text)
    case token
    when :dot
      @node << CharacterType::Any.new(type, token, text)
    when :alternation
      unless @node.token == :alternation
        alt = Alternation.new(type, token, text)

        if @node.expressions.last.is_a?(Literal)
          seq = Sequence.new
          while @node.expressions.last.is_a?(Literal)
            seq << @node.expressions.pop
          end
          alt << seq
        else
          alt << @node.expressions.pop
        end

        @node << alt
        @node = alt
      end
    else
      raise "Unsupported Meta token #{token.inspect}"
    end
  end

  def self.type(type, token, text)
    case token
    when :digit
      @node << CharacterType::Digit.new(type, token, text)
    when :nondigit
      @node << CharacterType::NonDigit.new(type, token, text)
    when :hex
      @node << CharacterType::Hex.new(type, token, text)
    when :nonhex
      @node << CharacterType::NonHex.new(type, token, text)
    when :space
      @node << CharacterType::Space.new(type, token, text)
    when :nonspace
      @node << CharacterType::NonSpace.new(type, token, text)
    when :word
      @node << CharacterType::Word.new(type, token, text)
    when :nonword
      @node << CharacterType::NonWord.new(type, token, text)
    else
      raise "Unsupported CharacterType token #{token.inspect}"
    end
  end

  def self.property(type, token, text)
    include Regexp::Expression::CharacterProperty

    case token
    when :alnum;            @node << Alnum.new(type, token, text)
    when :alpha;            @node << Alpha.new(type, token, text)
    when :any;              @node << Any.new(type, token, text)
    when :ascii;            @node << Ascii.new(type, token, text)
    when :blank;            @node << Blank.new(type, token, text)
    when :cntrl;            @node << Cntrl.new(type, token, text)
    when :digit;            @node << Digit.new(type, token, text)
    when :graph;            @node << Graph.new(type, token, text)
    when :lower;            @node << Lower.new(type, token, text)
    when :print;            @node << Print.new(type, token, text)
    when :punct;            @node << Punct.new(type, token, text)
    when :space;            @node << Space.new(type, token, text)
    when :upper;            @node << Upper.new(type, token, text)
    when :word;             @node << Word.new(type, token, text)
    when :xdigit;           @node << Xdigit.new(type, token, text)

    when :letter_any;       @node << Letter::Any.new(type, token, text)
    when :letter_uppercase; @node << Letter::Uppercase.new(type, token, text)
    when :letter_lowercase; @node << Letter::Lowercase.new(type, token, text)
    when :letter_titlecase; @node << Letter::Titlecase.new(type, token, text)
    when :letter_modifier;  @node << Letter::Modifier.new(type, token, text)
    when :letter_other;     @node << Letter::Other.new(type, token, text)

    when :mark_any;         @node << Mark::Any.new(type, token, text)
    when :mark_nonspacing;  @node << Mark::Nonspacing.new(type, token, text)
    when :mark_spacing;     @node << Mark::Spacing.new(type, token, text)
    when :mark_enclosing;   @node << Mark::Enclosing.new(type, token, text)

    when :number_any;       @node << Number::Any.new(type, token, text)
    when :number_decimal;   @node << Number::Decimal.new(type, token, text)
    when :number_letter;    @node << Number::Letter.new(type, token, text)
    when :number_other;     @node << Number::Other.new(type, token, text)

    when :punct_any;        @node << Punctuation::Any.new(type, token, text)
    when :punct_connector;  @node << Punctuation::Connector.new(type, token, text)
    when :punct_dash;       @node << Punctuation::Dash.new(type, token, text)
    when :punct_open;       @node << Punctuation::Open.new(type, token, text)
    when :punct_close;      @node << Punctuation::Close.new(type, token, text)
    when :punct_initial;    @node << Punctuation::Initial.new(type, token, text)
    when :punct_final;      @node << Punctuation::Final.new(type, token, text)
    when :punct_other;      @node << Punctuation::Other.new(type, token, text)

    when :separator_any;    @node << Separator::Any.new(type, token, text)
    when :separator_space;  @node << Separator::Space.new(type, token, text)
    when :separator_line;   @node << Separator::Line.new(type, token, text)
    when :separator_para;   @node << Separator::Paragraph.new(type, token, text)

    when :symbol_any;       @node << Symbol::Any.new(type, token, text)
    when :symbol_math;      @node << Symbol::Math.new(type, token, text)
    when :symbol_currency;  @node << Symbol::Currency.new(type, token, text)
    when :symbol_modifier;  @node << Symbol::Modifier.new(type, token, text)
    when :symbol_other;     @node << Symbol::Other.new(type, token, text)

    when :cp_any;           @node << Codepoint::Any.new(type, token, text)
    when :cp_control;       @node << Codepoint::Control.new(type, token, text)
    when :cp_format;        @node << Codepoint::Format.new(type, token, text)
    when :cp_surrogate;     @node << Codepoint::Surrogate.new(type, token, text)
    when :cp_private;       @node << Codepoint::PrivateUse.new(type, token, text)
    when :cp_unassigned;    @node << Codepoint::Unassigned.new(type, token, text)
    else
      raise "Unsupported UnicodeProperty token #{token.inspect}"
    end
  end

  def self.anchor(type, token, text)
    case token
    when :beginning_of_line
      @node << Anchor::BeginningOfLine.new(type, token, text)
    when :end_of_line
      @node << Anchor::EndOfLine.new(type, token, text)
    when :bos
      @node << Anchor::BOS.new(type, token, text)
    when :eos
      @node << Anchor::EOS.new(type, token, text)
    when :eos_ob_eol
      @node << Anchor::EOSobEOL.new(type, token, text)
    when :word_boundary
      @node << Anchor::WordBoundary.new(type, token, text)
    when :nonword_boundary
      @node << Anchor::NonWordBoundary.new(type, token, text)
    else
      raise "Unsupported Anchor token #{token.inspect}"
    end
  end

  def self.escape(type, token, text)
    case token

    when :backspace
      @node << EscapeSequence::Backspace.new(type, token, text)

    when :escape
      @node << EscapeSequence::AsciiEscape.new(type, token, text)
    when :bell
      @node << EscapeSequence::Bell.new(type, token, text)
    when :form_feed
      @node << EscapeSequence::FormFeed.new(type, token, text)
    when :newline
      @node << EscapeSequence::Newline.new(type, token, text)
    when :carriage
      @node << EscapeSequence::Return.new(type, token, text)
    when :space
      @node << EscapeSequence::Space.new(type, token, text)
    when :tab
      @node << EscapeSequence::Tab.new(type, token, text)
    when :vertical_tab
      @node << EscapeSequence::VerticalTab.new(type, token, text)

    when :control
      @node << EscapeSequence::Control.new(type, token, text)

    else
      # treating everything else as a literal
      @node << EscapeSequence::Literal.new(type, token, text)
    end
  end

  def self.quantifier(type, token, text)
    case token
    when :zero_or_one
      @node.expressions.last.quantify(:zero_or_one, text, 0, 1, :greedy)
    when :zero_or_one_reluctant
      @node.expressions.last.quantify(:zero_or_one, text, 0, 1, :reluctant)
    when :zero_or_one_possessive
      @node.expressions.last.quantify(:zero_or_one, text, 0, 1, :possessive)

    when :zero_or_more
      @node.expressions.last.quantify(:zero_or_more, text, 0, -1, :greedy)
    when :zero_or_more_reluctant
      @node.expressions.last.quantify(:zero_or_more, text, 0, -1, :reluctant)
    when :zero_or_more_possessive
      @node.expressions.last.quantify(:zero_or_more, text, 0, -1, :possessive)

    when :one_or_more
      @node.expressions.last.quantify(:one_or_more, text, 1, -1, :greedy)
    when :one_or_more_reluctant
      @node.expressions.last.quantify(:one_or_more, text, 1, -1, :reluctant)
    when :one_or_more_possessive
      @node.expressions.last.quantify(:one_or_more, text, 1, -1, :possessive)

    when :interval
      self.interval(text)

    else
      raise "Unsupported Quantifier token #{token.inspect}"
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

  def self.group(type, token, text)
    case token
    when :options
      self.options(type, token, text)
    when :close
      self.close_group
    when :comment
      @node << Group::Comment.new(type, token, text)
    else
      self.open_group(type, token, text)
    end
  end

  def self.options(type, token, text)
    opt = text.split('-', 2)

    exp = Group::Options.new(type, token, text)
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
      exp = Group::Passive.new(type, token, text)
    when :atomic
      exp = Group::Atomic.new(type, token, text)
    when :lookahead
      exp = Group::Lookahead.new(type, token, text)
    when :nlookahead
      exp = Group::NegativeLookahead.new(type, token, text)
    when :lookbehind
      exp = Group::Lookbehind.new(type, token, text)
    when :nlookbehind
      exp = Group::NegativeLookbehind.new(type, token, text)
    when :named
      exp = Group::Named.new(type, token, text)
    when :capture
      exp = Group::Capture.new(type, token, text)

    else
      raise "Unsupported Group type open token #{token.inspect}"
    end

    self.nest exp
  end

  def self.close_group
    last_group = @nesting.pop
    @node = @nesting.last
  end

  def self.open_set(type, token, text)
    @node << (@set = CharacterSet.new(type, token, text))
  end

  def self.negate_set
    @set.negate
  end

  def self.append_set(type, token, text)
    case token
    when :range
      # FIXME: this is naive
      parts = text.split('-', 2)
      range = (parts.first..parts.last).to_a
      range.each {|m| @set << m }
    else
      @set << text
    end
  end

  def self.close_set
  end

end # module Regexp::Parser
