%%{
  machine re_lex;
  include re_scanner "scanner.rl";
}%%

# Lexer
# 
module Regexp::Lexer
  %% write data;

  def self.lex(input, &block)
    top, stack = 0, []

    input = input.to_s if input.is_a?(Regexp)
    data = input.unpack("c*") if input.is_a?(String)
    eof  = data.length

    @tokens = []

    %% write init;
    %% write exec;

    if block_given?
      @tokens.each {|token| yield token}
    else
      @tokens
    end
  end

  def self.emit(type, id, text, ts, te)
    @tokens << Regexp::Token.new(type, id, text, ts, te)
  end
end # module Regexp::Lexer
