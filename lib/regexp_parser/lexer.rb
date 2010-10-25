# A very thin wrapper around the scanner that collects the tokens
# into an array, calculates their nesting depth, and checks if
# they are implemented by the given syntax flavor.
module Regexp::Lexer

  # TODO: complete, test token sets
  OPEN_TOKENS   = [:open, :capture, :options]
  CLOSE_TOKENS  = [:close]

  def self.scan(input, syntax = :any, &block)
    syntax = Regexp::Syntax.new(syntax)

    tokens = []
    nesting = 0

    Regexp::Scanner.scan(input) do |type, token, text, ts, te|
      syntax.check! type, token

      nesting -= 1 if CLOSE_TOKENS.include?(token)
      tokens << Regexp::Token.new(type, token, text, ts, te, nesting)
      nesting += 1 if OPEN_TOKENS.include?(token)
    end

    if block_given?
      tokens.each {|token| yield token}
    else
      tokens
    end
  end

end # module Regexp::Lexer
