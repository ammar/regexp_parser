%%{
  machine re_lex;
  include re_scanner "scanner.rl";
}%%

module Regexp::Lexer
  %% write data;

  def self.lex(input)
    top, stack = 0, []

    input = input.to_s if input.is_a?(Regexp)
    data = input.unpack("c*") if input.is_a?(String)
    eof  = data.length

    @tokens = []

    %% write init;
    %% write exec;

    @tokens
  end

  def self.emit(type, id, text, ts, te)
    @tokens << Regexp::Token.new(type, id, text, ts, te)
  end
end # module Regexp::Lexer
