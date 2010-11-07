require File.expand_path("../../helpers", __FILE__)

class ScannerGroups < Test::Unit::TestCase

  tests = {
    # Options
    '(?-mix:abc)'     => [0, :group,     :options,      '(?-mix:',    0, 7],
    '(?m-ix:abc)'     => [0, :group,     :options,      '(?m-ix:',    0, 7],
    '(?mi-x:abc)'     => [0, :group,     :options,      '(?mi-x:',    0, 7],
    '(?mix:abc)'      => [0, :group,     :options,      '(?mix:',     0, 6],

    # Group types
    '(?>abc)'         => [0, :group,     :atomic,       '(?>',        0, 3],
    '(abc)'           => [0, :group,     :capture,      '(',          0, 1],
    '(?<name>abc)'    => [0, :group,     :named,        '(?<name>',   0, 8],
    "(?'name'abc)"    => [0, :group,     :named_sq,     "(?'name'",   0, 8],
    '(?:abc)'         => [0, :group,     :passive,      '(?:',        0, 3],

    # Comments
    '(?#abc)'         => [0, :group,     :comment,      '(?#abc)',    0, 7],

    # Assertions
    '(?=abc)'         => [0, :assertion, :lookahead,    '(?=',        0, 3],
    '(?!abc)'         => [0, :assertion, :nlookahead,   '(?!',        0, 3],
    '(?<=abc)'        => [0, :assertion, :lookbehind,   '(?<=',       0, 4],
    '(?<!abc)'        => [0, :assertion, :nlookbehind,  '(?<!',       0, 4],
  }

  count = 0
  tests.each do |pattern, test|
    define_method "test_scan_#{test[1]}_#{test[2]}_#{count+=1}" do

      tokens = RS.scan(pattern)
      assert_equal( test[1,5], tokens[test[0]])
      assert_equal( test[3],   pattern[tokens[test[0]][3], tokens[test[0]][4]])

    end
  end

end
