# A very thin wrapper around the scanner that collects the tokens
# into an array, calculates their depths (nesting), and checks if
# the belong in the given regex syntax.
module Regexp::Lexer

  OPEN_TOKENS   = [:open, :capture, :options]
  CLOSE_TOKENS  = [:close]

  def self.scan(input, syntax = :any, &block)
    @depth  = 0
    @tokens = []
    @syntax = Regexp::Syntax.find(syntax)

    Regexp::Scanner.scan(input) do |type, token, text, ts, te|
      @syntax.check! type, token

      @depth -= 1 if CLOSE_TOKENS.include?(token)
      @tokens << Regexp::Token.new(type, token, text, ts, te, @depth)
      @depth += 1 if OPEN_TOKENS.include?(token)
    end

    if block_given?
      @tokens.each {|token| yield token}
    else
      @tokens
    end
  end

end # module Regexp::Lexer
