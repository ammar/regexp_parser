# scanner.rl imports the other files
RAGEL_SOURCE_PATH = File.join(__dir__, '../lib/regexp_parser/scanner/scanner.rl')
RAGEL_OUTPUT_PATH = File.join(__dir__, '../lib/regexp_parser/scanner.rb')

desc 'Process the ragel source files and output ruby code'
task ragel: 'ragel:install' do
  # -L = omit line hint comments; -p = print human-readable labels
  flags = ENV['DEBUG_RAGEL'].to_i == 1 ? ['-p'] : ['-L']
  # -F1 = use flat table-driven FSM, about 25% larger code, but about 30% faster
  flags << '-F1'
  sh 'ragel', '-R', RAGEL_SOURCE_PATH, '-o', RAGEL_OUTPUT_PATH, *flags

  cleaned_contents =
    File
    .read(RAGEL_OUTPUT_PATH)
    .gsub(/[ \t]+$/, '') # remove trailing whitespace emitted by ragel
    .gsub(/(?<=\d,)[ \t]+|^[ \t]+(?=-?\d)/, '') # compact FSM tables (saves ~6KB)
    .gsub(/\n(?:[ \t]*\n){2,}/, "\n\n") # compact blank lines

  File.open(RAGEL_OUTPUT_PATH, 'w') do |file|
    file.puts(<<-RUBY.gsub(/^\s+/, ''))
      # -*- warn-indent:false;  -*-
      #
      # THIS IS A GENERATED FILE, DO NOT EDIT DIRECTLY
      #
      # This file was generated from #{RAGEL_SOURCE_PATH.split('/').last}
      # by running `$ bundle exec rake ragel`
    RUBY

    file.write(cleaned_contents)
  end
end

namespace :ragel do
  desc 'Delete the ragel generated source file'
  task :clean do
    sh "rm -f #{RAGEL_OUTPUT_PATH}"
  end

  desc 'Make sure that ragel is installed'
  task :install do
    next if ENV['CI']

    if system('command -v ragel')
      # already installed
    elsif system('command -v brew')
      puts 'ragel not found, installing with homebrew ...'
      `brew install ragel`
    elsif system('command -v apt-get')
      puts 'ragel not found, installing with apt-get ...'
      `sudo apt-get install -y ragel`
    else
      raise 'Could not install ragel. Please install it manually.'
    end
  end

  desc 'Deprecated alias for the ragel task'
  task rb: :ragel do
    warn 'The `ragel:rb` task is deprecated, please use `ragel` instead.'
  end
end
