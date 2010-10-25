# A very thin wrapper around the scanner that collects the tokens
# into an array, calculates their nesting depth, and checks if
# they are implemented by the given syntax flavor.
module Regexp::Lexer

  # TODO: complete, test token sets
  OPENING_TOKENS = [:open, :capture, :options].freeze
  CLOSING_TOKENS = [:close].freeze

  def self.scan(input, syntax = :any, &block)
    syntax = Regexp::Syntax.new(syntax)

    tokens = []
    nesting = 0

    last = nil
    Regexp::Scanner.scan(input) do |type, token, text, ts, te|
      syntax.check! type, token

      nesting -= 1 if CLOSING_TOKENS.include?(token)

      current = Regexp::Token.new(type, token, text, ts, te, nesting)

      last.next(current) if last
      current.previous(last) if last

      tokens << current
      last = current

      nesting += 1 if OPENING_TOKENS.include?(token)
    end

    if block_given?
      tokens.each {|token| yield token}
    else
      tokens
    end
  end

end # module Regexp::Lexer
