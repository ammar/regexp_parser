BENCHMARKS_DIR = "#{__dir__}/benchmarks"

desc 'Run all IPS benchmarks'
task :benchmark do
  Dir["#{BENCHMARKS_DIR}/*.rb"].sort.each { |file| load(file) }
end

namespace :benchmark do
  desc 'Run all IPS benchmarks and store the comparison results in BENCHMARK.md'
  task :write_to_file do
    $store_comparison_results = {}

    Rake.application[:benchmark].invoke

    File.open("#{BENCHMARKS_DIR}/log", 'w') do |f|
      f.puts "Results of rake:benchmark on #{RUBY_DESCRIPTION}"

      $store_comparison_results.each do |caption, result|
        f.puts '', caption, '', result.strip.lines[1..-1]
      end
    end
  end
end
