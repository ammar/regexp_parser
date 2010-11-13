require File.expand_path("../../../helpers", __FILE__)

class TestSyntaxPosix_BRE < Test::Unit::TestCase

  tests = {
    # anchors
    '^abc$' => {
      0     => [:anchor,      :beginning_of_line,   '^',        0, 1, 0, 0],
      2     => [:anchor,      :end_of_line,         '$',        4, 5, 0, 0],
    },

    # groups and nesting
    'a\((b)\)cd' => {
      0     => [:literal,     :literal,             'a',        0, 1, 0, 0],
      1     => [:group,       :capture,             '\(',       1, 3, 0, 0],
      2     => [:literal,     :literal,             '(b)',      3, 6, 1, 0],
      3     => [:group,       :close,               '\)',       6, 8, 0, 0],
      4     => [:literal,     :literal,             'cd',       8, 10, 0, 0],
    },

    # quantifiers
    'ab+c\{0,2\}d*' => {
      0     => [:literal,     :literal,             'ab+',      0, 3, 0, 0],
      1     => [:literal,     :literal,             'c',        3, 4, 0, 0],
      2     => [:quantifier,  :interval_bre,        '\{0,2\}',  4, 11, 0, 0],
      3     => [:literal,     :literal,             'd',        11, 12, 0, 0],
      4     => [:quantifier,  :zero_or_more,        '*',        12, 13, 0, 0],
    },

    # escapes and back-references
    '\a\(b\)\1' => {
      0     => [:escape,      :literal,             '\a',       0, 2, 0, 0],
      4     => [:backref,     :digit,               '\1',       7, 9, 0, 0],
    },

    # character sets
    'a[^bd-f]c' => {
      1     => [:set,         :open,                '[',       1, 2, 0, 0],
      2     => [:set,         :negate,              '^',       2, 3, 0, 1],
      3     => [:set,         :member,              'b',       3, 4, 0, 1],
      4     => [:set,         :range,               'd-f',     4, 7, 0, 1],
      5     => [:set,         :close,               ']',       7, 8, 0, 0],
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
