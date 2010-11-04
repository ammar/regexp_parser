require File.expand_path("../../helpers", __FILE__)

class ScannerGroups < Test::Unit::TestCase

  tests = {
   '(?-mix)'       => [0, :group,     :options,     '(?-mix',     0, 6],

   '(?>abc)'       => [0, :group,     :atomic,      '(?>',        0, 3],
   '(abc)'         => [0, :group,     :capture,     '(',          0, 1],
   '(?<name>abc)'  => [0, :group,     :named,       '(?<name>',   0, 8],
   "(?'name'abc)"  => [0, :group,     :named_sq,    "(?'name'",   0, 8],
   '(?:abc)'       => [0, :group,     :passive,     '(?:',        0, 3],

   '(?#abc)'       => [0, :group,     :comment,     '(?#abc)',    0, 7],

   '(?=abc)'       => [0, :assertion, :lookahead,   '(?=',        0, 3],
   '(?!abc)'       => [0, :assertion, :nlookahead,  '(?!',        0, 3],
   '(?<=abc)'      => [0, :assertion, :lookbehind,  '(?<=',       0, 4],
   '(?<!abc)'      => [0, :assertion, :nlookbehind, '(?<!',       0, 4],
  }

  count = 0
  tests.each do |pattern, test|
    define_method "test_scan_#{test[1]}_#{test[2]}_#{count+=1}" do

      token = RS.scan(pattern)[0]
      assert_equal( test[1,5], token)

    end
  end

end
