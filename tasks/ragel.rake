RAGEL_SOURCE_DIR = File.join(__dir__, '../lib/regexp_parser/scanner')
RAGEL_OUTPUT_DIR = File.join(__dir__, '../lib/regexp_parser')
RAGEL_SOURCE_FILES = %w[scanner] # scanner.rl imports the other files

namespace :ragel do
  desc 'Process the ragel source files and output ruby code'
  task :rb do
    RAGEL_SOURCE_FILES.each do |source_file|
      output_file = "#{RAGEL_OUTPUT_DIR}/#{source_file}.rb"
      # using faster flat table driven FSM, about 25% larger code, but about 30% faster
      sh "ragel -F1 -R #{RAGEL_SOURCE_DIR}/#{source_file}.rl -o #{output_file}"

      contents = File.read(output_file)

      File.open(output_file, 'r+') do |file|
        contents = "# -*- warn-indent:false;  -*-\n" + contents

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
end
