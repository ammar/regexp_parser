# frozen_string_literal: true

require_relative 'shared'

puts 'Regexp::Expression traversal'

tree = Regexp::Parser.parse(URI_REGEXP)

Benchmark.ips do |x|
  x.report('#each_expression') { tree.each_expression { |e| e } }
  x.report('#each_expression w. index') { tree.each_expression { |e, _i| e } }
  x.report('#traverse') { tree.traverse { |_event, e, _i| e } }
  x.compare!
end
