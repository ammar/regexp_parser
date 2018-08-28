# A very thin wrapper around the scanner that breaks quantified literal runs,
# collects emitted tokens into an array, calculates their nesting depth, and
# normalizes tokens for the parser, and checks if they are implemented by the
# given syntax flavor.
class Regexp::Lexer

  OPENING_TOKENS = [
    :capture, :passive, :lookahead, :nlookahead, :lookbehind, :nlookbehind,
    :atomic, :options, :options_switch, :named, :absence
  ].freeze

  CLOSING_TOKENS = [:close].freeze

  def self.lex(input, syntax = "ruby/#{RUBY_VERSION}", &block)
    new.lex(input, syntax, &block)
  end

  def lex(input, syntax = "ruby/#{RUBY_VERSION}", &block)
    syntax = Regexp::Syntax.new(syntax)

    self.tokens = []
    self.nesting = 0
    self.set_nesting = 0
    self.conditional_nesting = 0

    last = nil
    Regexp::Scanner.scan(input) do |type, token, text, ts, te|
      type, token = *syntax.normalize(type, token)
      syntax.check! type, token

      ascend(type, token)

      break_literal(last) if type == :quantifier and
        last and last.type == :literal

      current = Regexp::Token.new(type, token, text, ts, te,
                nesting, set_nesting, conditional_nesting)

      current = merge_literal(current) if type == :literal and
        set_nesting == 0 and
        last and last.type == :literal

      current = merge_condition(current) if type == :conditional and
        [:condition, :condition_close].include?(token)

      last.next = current if last
      current.previous = last if last

      tokens << current
      last = current

      descend(type, token)
    end

    if block_given?
      tokens.map { |t| block.call(t) }
    else
      tokens
    end
  end

  class << self
    alias :scan :lex
  end

  private

  attr_accessor :tokens, :nesting, :set_nesting, :conditional_nesting

  def ascend(type, token)
    case type
    when :group, :assertion
      self.nesting = nesting - 1 if CLOSING_TOKENS.include?(token)
    when :set
      self.set_nesting = set_nesting - 1 if token == :close
    when :conditional
      self.conditional_nesting = conditional_nesting - 1 if token == :close
    end
  end

  def descend(type, token)
    case type
    when :group, :assertion
      self.nesting = nesting + 1 if OPENING_TOKENS.include?(token)
    when :set
      self.set_nesting = set_nesting + 1 if token == :open
    when :conditional
      self.conditional_nesting = conditional_nesting + 1 if token == :open
    end
  end

  # called by scan to break a literal run that is longer than one character
  # into two separate tokens when it is followed by a quantifier
  def break_literal(token)
    text = token.text
    if text.scan(/./mu).length > 1
      lead = text.sub(/.\z/mu, "")
      last = text[/.\z/mu] || ''

      if RUBY_VERSION >= '1.9'
        lead_length = lead.bytesize
        last_length = last.bytesize
      else
        lead_length = lead.length
        last_length = last.length
      end

      tokens.pop
      tokens << Regexp::Token.new(:literal, :literal, lead, token.ts,
                (token.te - last_length), nesting, set_nesting, conditional_nesting)

      tokens << Regexp::Token.new(:literal, :literal, last,
                (token.ts + lead_length),
                token.te, nesting, set_nesting, conditional_nesting)
    end
  end

  # called by scan to merge two consecutive literals. this happens when tokens
  # get normalized (as in the case of posix/bre) and end up becoming literals.
  def merge_literal(current)
    last = tokens.pop

    Regexp::Token.new(
      :literal,
      :literal,
      last.text + current.text,
      last.ts,
      current.te,
      nesting,
      set_nesting,
      conditional_nesting,
    )
  end

  def merge_condition(current)
    last = tokens.pop
    Regexp::Token.new(:conditional, :condition, last.text + current.text,
      last.ts, current.te, nesting, set_nesting, conditional_nesting)
  end

end # module Regexp::Lexer
