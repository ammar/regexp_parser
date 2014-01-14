require 'rake'
require 'rake/testtask'
require 'rubygems/package_task'
require 'yaml'

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
  %w{scanner lexer parser expression syntax}.each do |component|
    Rake::TestTask.new(component) do |t|
      t.libs << "test"
      t.test_files = ["test/#{component}/test_all.rb"]
    end
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

spec = Gem::Specification.new do |gem|
  gem.name = 'regexp_parser'
  gem.version = YAML.load(File.read('VERSION.yml')).values.compact.join('.')
  gem.date = '2014-01-14'

  gem.license = 'MIT'
  gem.summary = %q{Scanner, lexer, parser for ruby's regular expressions}
  gem.description = %q{A library for tokenizing, lexing, and parsing Ruby regular expressions.}
  gem.homepage = %q{http://github.com/ammar/regexp_parser}

  gem.authors = ["Ammar Ali"]
  gem.email = 'ammarabuali@gmail.com'

  gem.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  gem.extra_rdoc_files = ["ChangeLog", "LICENSE", "README.rdoc"]

  gem.require_paths = ["lib"]

  gem.files = Dir.glob("{lib,test}/**/*.rb") + Dir.glob("lib/**/*.rl") +
              %w(VERSION.yml Rakefile LICENSE README.rdoc ChangeLog)

  gem.test_files = Dir.glob("test/**/*.rb")

  gem.required_rubygems_version = Gem::Requirement.new(">= 0") if
    gem.respond_to? :required_rubygems_version=
end

Gem::PackageTask.new(spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end

namespace :gem do
  desc "Release the gem to rubygems.org"
  task :release do |t|
    Rake::Task['ragel:rb'].execute
    Rake::Task['repackage'].execute
    #sh "gem push"
  end
end
