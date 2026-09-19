# frozen_string_literal: true

require_relative 'shared'

puts 'Parsing a minimal Regexp'

regexp = /./

Benchmark.ips do |x|
  x.report('Scanner::scan') { Regexp::Scanner.scan(regexp) }
  x.report('Lexer::lex')    { Regexp::Lexer.lex(regexp)    }
  x.report('Parser::parse') { Regexp::Parser.parse(regexp) }
  x.compare!
end
