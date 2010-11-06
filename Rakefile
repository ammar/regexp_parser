require 'rake'
require 'rake/testtask'

task :default => [:test]

RAGEL_SOURCE_DIR = File.expand_path '../lib/regexp_parser/scanner', __FILE__
RAGEL_OUTPUT_DIR = File.expand_path '../lib/regexp_parser', __FILE__

RAGEL_SOURCE_FILES = %w{scanner}

desc "Find and run all unit tests under test/ directory"
Rake::TestTask.new("test") do |t|
  #t.verbose = true
  t.libs << "test"
  t.test_files = FileList['test/**/test_*.rb']
end

task :test

namespace :test do
  desc "Run all scanner tests"
  Rake::TestTask.new("scanner") do |t|
    t.libs << "test"
    t.test_files = ['test/scanner/test_all.rb']
  end

  desc "Run all lexer tests"
  Rake::TestTask.new("lexer") do |t|
    t.libs << "test"
    t.test_files = ['test/lexer/test_all.rb']
  end

  desc "Run all parser tests"
  Rake::TestTask.new("parser") do |t|
    t.libs << "test"
    t.test_files = ['test/parser/test_all.rb']
  end
end

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
