require File.expand_path("../../helpers", __FILE__)

class ScannerGroups < Test::Unit::TestCase

  tests = {
    # Options
    '(?-mix:abc)'     => [0, :group,     :options,      '(?-mix:',    0, 7],
    '(?m-ix:abc)'     => [0, :group,     :options,      '(?m-ix:',    0, 7],
    '(?mi-x:abc)'     => [0, :group,     :options,      '(?mi-x:',    0, 7],
    '(?mix:abc)'      => [0, :group,     :options,      '(?mix:',     0, 6],
    '(?mix)'          => [0, :group,     :options,      '(?mix',      0, 5],
    '(?m:)'           => [0, :group,     :options,      '(?m:',       0, 4],
    '(?i:)'           => [0, :group,     :options,      '(?i:',       0, 4],
    '(?x:)'           => [0, :group,     :options,      '(?x:',       0, 4],

    # Group types
    '(?>abc)'         => [0, :group,     :atomic,       '(?>',        0, 3],
    '(abc)'           => [0, :group,     :capture,      '(',          0, 1],

    '(?<name>abc)'    => [0, :group,     :named_ab,     '(?<name>',   0, 8],
    "(?'name'abc)"    => [0, :group,     :named_sq,     "(?'name'",   0, 8],

    '(?<name_1>abc)'  => [0, :group,     :named_ab,     '(?<name_1>', 0,10],
    "(?'name_1'abc)"  => [0, :group,     :named_sq,     "(?'name_1'", 0,10],

    '(?:abc)'         => [0, :group,     :passive,      '(?:',        0, 3],
    '(?:)'            => [0, :group,     :passive,      '(?:',        0, 3],
    '(?::)'           => [0, :group,     :passive,      '(?:',        0, 3],

    # Comments
    '(?#abc)'         => [0, :group,     :comment,      '(?#abc)',    0, 7],
    '(?#)'            => [0, :group,     :comment,      '(?#)',       0, 4],

    # Assertions
    '(?=abc)'         => [0, :assertion, :lookahead,    '(?=',        0, 3],
    '(?!abc)'         => [0, :assertion, :nlookahead,   '(?!',        0, 3],
    '(?<=abc)'        => [0, :assertion, :lookbehind,   '(?<=',       0, 4],
    '(?<!abc)'        => [0, :assertion, :nlookbehind,  '(?<!',       0, 4],
  }

  if RUBY_VERSION >= '2.0'
    tests.merge!({
      # New options
      '(?d-mix:abc)'  => [0, :group,     :options,      '(?d-mix:',   0, 8],
      '(?a-mix:abc)'  => [0, :group,     :options,      '(?a-mix:',   0, 8],
      '(?u-mix:abc)'  => [0, :group,     :options,      '(?u-mix:',   0, 8],
      '(?da-m:abc)'   => [0, :group,     :options,      '(?da-m:',    0, 7],
      '(?du-x:abc)'   => [0, :group,     :options,      '(?du-x:',    0, 7],
      '(?dau-i:abc)'  => [0, :group,     :options,      '(?dau-i:',   0, 8],
      '(?dau:abc)'    => [0, :group,     :options,      '(?dau:',     0, 6],
      '(?dau)'        => [0, :group,     :options,      '(?dau',      0, 5],
      '(?d:)'         => [0, :group,     :options,      '(?d:',       0, 4],
      '(?a:)'         => [0, :group,     :options,      '(?a:',       0, 4],
      '(?u:)'         => [0, :group,     :options,      '(?u:',       0, 4],
    })
  end

  if RUBY_VERSION >= '2.4.1'
    tests.merge!({
      # New absence operator
      '(?~abc)'       => [0, :group,     :absence,      '(?~',        0, 3],
    })
  end

  tests.each_with_index do |(pattern, (index, type, token, text, ts, te)), count|
    define_method "test_scanner_#{type}_#{token}_#{count}" do
      tokens = RS.scan(pattern)
      result = tokens[index]

      assert_equal type,  result[0]
      assert_equal token, result[1]
      assert_equal text,  result[2]
      assert_equal ts,    result[3]
      assert_equal te,    result[4]
      assert_equal text,  pattern[ts, te]
    end
  end

end
