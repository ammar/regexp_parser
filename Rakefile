require 'rake'
require 'rake/testtask'
require 'rake/gempackagetask'

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

spec = Gem::Specification.new do |s|
  s.name = 'regexp_parser'
  s.version = '0.1.0'
  s.summary = %q{Scanner, lexer, parser for ruby's regular expressions}
  s.description = %q{A library for tokenizing, lexing, and parsing Ruby regular expressions.}
  s.date = '2010-10-01'
  s.authors = ["Ammar Ali"]
  s.email = 'ammarabuali@gmail.com'
  s.homepage = %q{http://github.com/ammar/regexp_parser}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}

  s.files = Dir.glob("{lib,test}/**/*.rb") + Dir.glob("lib/**/*.rl") +
            %w(Rakefile LICENSE README.rdoc ChangeLog)

  s.test_files = Dir.glob("test/**/*.rb")
  s.extra_rdoc_files = ["ChangeLog", "LICENSE", "README.rdoc"]
  s.required_rubygems_version = ">= 1.3.7"
  s.rubyforge_project = "regexp_parser"
  s.require_path = 'lib'
end

Rake::GemPackageTask.new(spec) do |pkg|
  Rake::Task['ragel:rb'].execute

  pkg.need_zip = true
  pkg.need_tar = true
end
