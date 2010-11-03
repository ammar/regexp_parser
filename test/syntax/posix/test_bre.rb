require File.expand_path("../../../helpers", __FILE__)

class TestSyntaxPosix_BRE < Test::Unit::TestCase

  tests = {
    'a\((b)\)cd' => {
      0     => [:literal,     :literal,       'a',        0, 1, 0],
      1     => [:group,       :capture,       '\(',       1, 3, 0],
      2     => [:literal,     :literal,       '(',        3, 4, 1],
      3     => [:literal,     :literal,       'b',        4, 5, 1],
      4     => [:literal,     :literal,       ')',        5, 6, 1],
      5     => [:group,       :close,         '\)',       6, 8, 0],
      6     => [:literal,     :literal,       'cd',       8, 10, 0],
    },

    'abc\{0,2\}d' => {
      0     => [:literal,     :literal,       'ab',       0, 2, 0],
      1     => [:literal,     :literal,       'c',        2, 3, 0],
      2     => [:quantifier,  :interval_bre,  '\{0,2\}',  3, 10, 0],
      3     => [:literal,     :literal,       'd',        10, 11, 0],
    },
  }

  count = 0
  tests.each do |pattern, checks|
    define_method "test_syntax_bre_#{count+=1}" do

      tokens = RL.scan(pattern, 'posix/bre')
      checks.each do |offset, token|
        assert_equal( token, tokens[offset].to_a )
      end

    end
  end

  def test_lexer_syntax_posix_bre
    assert_instance_of( Array, RL.scan('abc', 'posix/bre'))
  end

end
