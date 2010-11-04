require File.expand_path("../../helpers", __FILE__)

class LexerNesting < Test::Unit::TestCase

  tests = {
    '(((b)))' => {
      0     => [:group,       :capture,       '(',    0, 1, 0],
      1     => [:group,       :capture,       '(',    1, 2, 1],
      2     => [:group,       :capture,       '(',    2, 3, 2],
      3     => [:literal,     :literal,       'b',    3, 4, 3],
      4     => [:group,       :close,         ')',    4, 5, 2],
      5     => [:group,       :close,         ')',    5, 6, 1],
      6     => [:group,       :close,         ')',    6, 7, 0],
    },

    '(\((b)\))' => {
      0     => [:group,       :capture,       '(',    0, 1, 0],
      1     => [:escape,      :group_open,    '\(',   1, 3, 1], # TODO: normalize in syntax
      2     => [:group,       :capture,       '(',    3, 4, 1],
      3     => [:literal,     :literal,       'b',    4, 5, 2],
      4     => [:group,       :close,         ')',    5, 6, 1],
      5     => [:escape,      :group_close,   '\)',   6, 8, 1], # TODO: normalize in syntax
      6     => [:group,       :close,         ')',    8, 9, 0],
    },
  }

  count = 0
  tests.each do |pattern, checks|
    define_method "test_lex_nesting_#{count+=1}" do

      tokens = RL.scan(pattern, 'ruby/1.8')
      checks.each do |offset, token|
        assert_equal( token, tokens[offset].to_a )
      end

    end
  end

end
