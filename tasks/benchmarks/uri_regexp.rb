# frozen_string_literal: true

require_relative 'shared'

puts 'Parsing a complex Regexp (URI.regexp)'

Benchmark.ips do |x|
  x.report('Scanner::scan') { Regexp::Scanner.scan(URI_REGEXP) }
  x.report('Lexer::lex')    { Regexp::Lexer.lex(URI_REGEXP)    }
  x.report('Parser::parse') { Regexp::Parser.parse(URI_REGEXP) }
  x.compare!
end
