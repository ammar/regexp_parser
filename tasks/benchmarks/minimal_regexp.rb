require_relative './shared'

regexp = /./

benchmark(
  caption: 'Parsing a minimal Regexp',
  cases: {
    'Scanner::scan' => -> { Regexp::Scanner.scan(regexp) },
    'Lexer::lex'    => -> { Regexp::Lexer.lex(regexp) },
    'Parser::parse' => -> { Regexp::Parser.parse(regexp) },
  },
)
