require 'pathname'

module RegexpParserTest
  class Runner
    def initialize(arguments, warning_whitelist)
      @arguments = arguments
      @warning_whitelist = warning_whitelist
    end

    def run
      test_status = nil

      Warning::Filter.new(warning_whitelist).assert_expected_warnings_only do
        setup
        test_status = run_test_unit
      end

      test_status
    end

    private

    def setup
      $VERBOSE = true

      test_files.each(&method(:require))
    end

    def run_test_unit
      Test::Unit::AutoRunner.run
    end

    def test_files
      arguments
        .map { |path| Pathname.new(path).expand_path.freeze }
        .select(&:file?)
    end

    attr_reader :arguments, :warning_whitelist
  end
end
