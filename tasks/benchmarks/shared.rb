lib = File.expand_path('../../lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'benchmark/ips'
require 'stringio'
require 'regexp_parser'

def benchmark(caption: nil, cases: {})
  puts caption

  report = Benchmark.ips do |x|
    cases.each do |label, callable|
      x.report(label, &callable)
    end
    x.compare!
  end

  return unless $store_comparison_results

  old_stdout = $stdout.clone
  captured_stdout = StringIO.new
  $stdout = captured_stdout
  report.run_comparison
  $store_comparison_results[caption] = captured_stdout.string
  $stdout = old_stdout
end
