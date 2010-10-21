%%{
  machine re_lex;
  include re_scanner "scanner.rl";
}%%

# A very thin wrapper around the scanner that collects the expression tokens
# into an array and calculates their depths in the process.
module Regexp::Lexer
  %% write data;

  OPEN_TOKENS   = [:open, :capture, :options]
  CLOSE_TOKENS  = [:close]

  def self.lex(input, &block)
    top, stack = 0, []

    input = input.to_s if input.is_a?(Regexp)
    data = input.unpack("c*") if input.is_a?(String)
    eof  = data.length

    @depth = 0
    @tokens = []

    %% write init;
    %% write exec;

    if block_given?
      @tokens.each {|token| yield token}
    else
      @tokens
    end
  end

  def self.emit(type, token, text, ts, te)
    @depth -= 1 if CLOSE_TOKENS.include?(token)
    @tokens << Regexp::Token.new(type, token, text, ts, te, @depth)
    @depth += 1 if OPEN_TOKENS.include?(token)
  end
end # module Regexp::Lexer
