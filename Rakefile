require 'rubygems'

require 'rake'
require 'rake/testtask'

require 'bundler'
require 'rubygems/package_task'


RAGEL_SOURCE_DIR = File.expand_path '../lib/regexp_parser/scanner', __FILE__
RAGEL_OUTPUT_DIR = File.expand_path '../lib/regexp_parser', __FILE__
RAGEL_SOURCE_FILES = %w{scanner} # scanner.rl includes property.rl


Bundler::GemHelper.install_tasks


task :default => [:'test:full']

namespace :test do
  task full: :'ragel:rb' do
    sh 'bin/test'
  end
end

namespace :ragel do
  desc "Process the ragel source files and output ruby code"
  task :rb do |t|
    RAGEL_SOURCE_FILES.each do |file|
      output_file = "#{RAGEL_OUTPUT_DIR}/#{file}.rb"
      # using faster flat table driven FSM, about 25% larger code, but about 30% faster
      sh "ragel -F1 -R #{RAGEL_SOURCE_DIR}/#{file}.rl -o #{output_file}"

      contents = File.read(output_file)

      File.open(output_file, 'r+') do |file|
        contents = "# -*- warn-indent:false;  -*-\n" + contents

        file.write(contents)
      end
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

