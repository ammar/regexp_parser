require 'rake'

RAGEL_SOURCE_DIR = File.expand_path '../lib/regexp_parser', __FILE__
RAGEL_OUTPUT_DIR = File.expand_path '../lib/regexp_parser', __FILE__

RAGEL_SOURCE_FILES = %w{lexer parser}

namespace :ragel do
  desc "Process the ragel source file(s) and output the ruby code"
  task :build do |t|
    RAGEL_SOURCE_FILES.each do |file|
      sh "ragel -R #{RAGEL_SOURCE_DIR}/#{file}.rl -o #{RAGEL_OUTPUT_DIR}/#{file}.rb"
    end
  end

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
