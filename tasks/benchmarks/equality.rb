# frozen_string_literal: true

require_relative 'shared'

puts 'Comparing a complex Regexp (URI.regexp)'

tree1 = Regexp::Parser.parse(URI_REGEXP)
tree2 = Regexp::Parser.parse(URI_REGEXP)
uri_regexp_copy = URI_REGEXP.dup

Benchmark.ips do |x|
  x.report('Regexp#==') { URI_REGEXP == uri_regexp_copy }
  x.report('Expression#==') { tree1 == tree2 }
  x.compare!
end
