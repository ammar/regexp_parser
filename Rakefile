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

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = %q{regexp_parser}

    s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
    s.authors = ["Ammar Ali"]
    s.date = %q{2010-10-01}
    s.description = %q{Scanner, lexer, parser for ruby's regular expressions}
    s.email = %q{ammarabuali@gmail.com}
    s.has_rdoc = true
    s.homepage = "http://github.com/ammar/regexp_parser/tree/master"
    s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
    s.require_paths = ["lib"]
    s.bindir = "bin"
    s.executables = ['re2en']
    s.summary = %q{Command line time tracker}
    s.add_dependency("sequel", ">= 3.9.0")
    s.add_dependency("sqlite3-ruby", ">= 1.2.5")
    s.add_dependency("chronic", "~> 0.3.0")
    s.add_dependency("getopt-declare", ">= 1.28")
    s.add_dependency("icalendar", ">= 1.1.2")
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end
