require 'rake'
require 'rake/testtask'

task :default => [:test]

RAGEL_SOURCE_DIR = File.expand_path '../lib/regexp_parser', __FILE__
RAGEL_OUTPUT_DIR = File.expand_path '../lib/regexp_parser', __FILE__

RAGEL_SOURCE_FILES = %w{lexer parser}

namespace :ragel do
  desc "Process the ragel source files and output ruby code"
  task :rb do |t|
    RAGEL_SOURCE_FILES.each do |file|
      sh "ragel -R #{RAGEL_SOURCE_DIR}/#{file}.rl -o #{RAGEL_OUTPUT_DIR}/#{file}.rb"
    end
  end

  desc "Process the ragel source file(s) and output the ruby code"
  task :clean do |t|
    RAGEL_SOURCE_FILES.each do |file|
      sh "rm -f #{RAGEL_OUTPUT_DIR}/#{file}.rb"
    end
  end
end

namespace :yard do
end

namespace :rcov do
end


desc "Find and run all unit tests under test/ directory"
Rake::TestTask.new("test") do |t|
  #t.verbose = true
  t.libs << "test"
  t.test_files = FileList['test/**/test_*.rb']
end
task :test
