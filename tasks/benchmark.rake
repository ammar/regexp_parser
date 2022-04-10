BENCHMARKS_DIR = "#{__dir__}/benchmarks"

desc 'Run all IPS benchmarks'
task :benchmark do
  Dir["#{BENCHMARKS_DIR}/*.rb"].sort.each { |file| load(file) }
end

namespace :benchmark do
  desc 'Run all IPS benchmarks and store the comparison results in BENCHMARK.md'
  task :write_to_file do
    require 'stringio'

    string_io = StringIO.new
    with_stdouts(STDOUT, string_io) { Rake.application[:benchmark].invoke }

    File.write "#{BENCHMARKS_DIR}/log",
               "Results of rake:benchmark on #{RUBY_DESCRIPTION}\n\n" +
               string_io.string.gsub(/Warming up.*?Comparison:/m, '')
  end
end

def with_stdouts(*ios)
  old_stdout = $stdout
  ios.define_singleton_method(:method_missing) { |*args| each { |io| io.send(*args) } }
  ios.define_singleton_method(:respond_to?) { |*args| IO.respond_to?(*args) }
  $stdout = ios
  yield
ensure
  $stdout = old_stdout
end
