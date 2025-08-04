# frozen_string_literal: true

require 'benchmark/ips'
require_relative '../../lib/regexp_parser'

puts 'Parsing a complex Regexp (URI.regexp)'

require 'uri'
regexp = URI::DEFAULT_PARSER.make_regexp

Benchmark.ips do |x|
  x.report('Scanner::scan') { Regexp::Scanner.scan(regexp) }
  x.report('Lexer::lex')    { Regexp::Lexer.lex(regexp)    }
  x.report('Parser::parse') { Regexp::Parser.parse(regexp) }
  x.compare!
end
