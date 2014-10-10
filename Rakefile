require 'rubygems'

require 'rake'
require 'rake/testtask'

require 'bundler'
require 'rubygems/package_task'


RAGEL_SOURCE_DIR = File.expand_path '../lib/regexp_parser/scanner', __FILE__
RAGEL_OUTPUT_DIR = File.expand_path '../lib/regexp_parser', __FILE__
RAGEL_SOURCE_FILES = %w{scanner} # scanner.rl includes property.rl


Bundler::GemHelper.install_tasks


task :default => [:test]

Rake::TestTask.new('test') do |t|
  if t.respond_to?(:description)
    t.description = "Run all unit tests under the test directory"
  end

  t.libs << "test"
  t.test_files = FileList['test/test_all.rb']
end

namespace :test do
  %w{scanner lexer parser expression syntax}.each do |component|
    Rake::TestTask.new(component) do |t|
      if t.respond_to?(:description)
        t.description = "Run all #{component} unit tests under the test/#{component} directory"
      end

      t.libs << "test"
      t.test_files = ["test/#{component}/test_all.rb"]
    end
  end

  Rake::TestTask.new('full' => 'ragel:rb') do |t|
    if t.respond_to?(:description)
      t.description = "Regenerate the scanner and run all unit tests under the test directory"
    end

    t.libs << "test"
    t.test_files = FileList['test/test_all.rb']
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


# Add ragel task as a prerequisite for building the gem to ensure that the
# latest scanner code is generated and included in the build.
desc "Runs ragel:rb before building the gem"
task :build => ['ragel:rb']

