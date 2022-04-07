require_relative './shared'
require 'uri'

regexp = URI::DEFAULT_PARSER.make_regexp

benchmark(
  caption: 'Parsing a complex Regexp (URI.regexp)',
  cases: {
    'Scanner::scan' => -> { Regexp::Scanner.scan(regexp) },
    'Lexer::lex'    => -> { Regexp::Lexer.lex(regexp) },
    'Parser::parse' => -> { Regexp::Parser.parse(regexp) },
  },
)
