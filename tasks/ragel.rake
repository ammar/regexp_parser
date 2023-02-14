RAGEL_SOURCE_DIR = File.join(__dir__, '../lib/regexp_parser/scanner')
RAGEL_OUTPUT_DIR = File.join(__dir__, '../lib/regexp_parser')
RAGEL_SOURCE_FILES = %w[scanner] # scanner.rl imports the other files

namespace :ragel do
  desc 'Process the ragel source files and output ruby code'
  task rb: :install do |task|
    RAGEL_SOURCE_FILES.each do |source_file|
      source_path = "#{RAGEL_SOURCE_DIR}/#{source_file}.rl"
      output_path = "#{RAGEL_OUTPUT_DIR}/#{source_file}.rb"
      # -L = omit line hint comments
      flags = ENV['DEBUG_RAGEL'].to_i == 1 ? ['-p'] : ['-L']
      # using faster flat table driven FSM, about 25% larger code, but about 30% faster
      flags << '-F1'
      sh "ragel -R #{source_path} -o #{output_path} #{flags.join(' ')}"

      contents = File
        .read(output_path)
        .gsub(/[ \t]+$/, '') # remove trailing whitespace emitted by ragel
        .gsub(/(?<=\d,)[ \t]+|^[ \t]+(?=-?\d)/, '') # compact FSM tables (saves ~6KB)
        .gsub(/\n(?:[ \t]*\n){2,}/, "\n\n") # compact blank lines

      File.open(output_path, 'w') do |file|
        file.puts <<~RUBY
          # -*- warn-indent:false;  -*-
          #
          # THIS IS A GENERATED FILE, DO NOT EDIT DIRECTLY
          #
          # This file was generated from #{source_path.split('/').last}
          # by running `bundle exec rake #{task.name}`
        RUBY

        file.write(contents)
      end
    end
  end

  desc 'Delete the ragel generated source file(s)'
  task :clean do
    RAGEL_SOURCE_FILES.each do |file|
      sh "rm -f #{RAGEL_OUTPUT_DIR}/#{file}.rb"
    end
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
end
