require 'rake'
require 'rake/testtask'

task :default => [:test]

RAGEL_SOURCE_DIR = File.expand_path '../lib/regexp_parser/scanner', __FILE__
RAGEL_OUTPUT_DIR = File.expand_path '../lib/regexp_parser', __FILE__

RAGEL_SOURCE_FILES = %w{scanner}

desc "Find and run all unit tests under test/ directory"
Rake::TestTask.new("test") do |t|
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

  desc "Run all syntax tests"
  Rake::TestTask.new("syntax") do |t|
    t.libs << "test"
    t.test_files = ['test/syntax/test_all.rb']
  end
end

namespace :ragel do
  desc "Process the ragel source files and output ruby code"
  task :rb do |t|
    RAGEL_SOURCE_FILES.each do |file|
      # using faster flat table driven FSM, about 25% larger code, but about 30% faster
      sh "ragel -F1 -R #{RAGEL_SOURCE_DIR}/#{file}.rl -o #{RAGEL_OUTPUT_DIR}/#{file}.rb"
    end
  end

  desc "Delete the ragel generated source file(s)"
  task :clean do |t|
    RAGEL_SOURCE_FILES.each do |file|
      sh "rm -f #{RAGEL_OUTPUT_DIR}/#{file}.rb"
    end
  end
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = %q{regexp_parser}
    gem.summary = %q{A library for tokenizing, lexing, and parsing Ruby regular expressions.}
    gem.version = "0.1.0"
    gem.date = %q{2010-10-01}
    gem.authors = ["Ammar Ali"]
    gem.description = %q{Scanner, lexer, parser for ruby's regular expressions}
    gem.email = %q{ammarabuali@gmail.com}
    gem.has_rdoc = true
    gem.homepage = "http://github.com/ammar/regexp_parser"
    gem.rdoc_options = ["--inline-source", "--charset=UTF-8"]
    gem.require_paths = ["lib"]
    gem.required_rubygems_version = Gem::Requirement.new(">= 0") if gem.respond_to? :required_rubygems_version=
    gem.files.include 'lib/regexp_parser/scanner.rb'

    Rake::Task['ragel:rb'].execute
  end
rescue LoadError
  puts "Jeweler is not installed. Install it with: sudo gem install jeweler"
end
