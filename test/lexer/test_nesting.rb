require File.expand_path("../../helpers", __FILE__)

class LexerNesting < Test::Unit::TestCase

  tests = {
    '(((b)))' => {
      0     => [:group,       :capture,       '(',      0,  1, 0],
      1     => [:group,       :capture,       '(',      1,  2, 1],
      2     => [:group,       :capture,       '(',      2,  3, 2],
      3     => [:literal,     :literal,       'b',      3,  4, 3],
      4     => [:group,       :close,         ')',      4,  5, 2],
      5     => [:group,       :close,         ')',      5,  6, 1],
      6     => [:group,       :close,         ')',      6,  7, 0],
    },

    '(\((b)\))' => {
      0     => [:group,       :capture,       '(',      0,  1, 0],
      1     => [:escape,      :group_open,    '\(',     1,  3, 1],
      2     => [:group,       :capture,       '(',      3,  4, 1],
      3     => [:literal,     :literal,       'b',      4,  5, 2],
      4     => [:group,       :close,         ')',      5,  6, 1],
      5     => [:escape,      :group_close,   '\)',     6,  8, 1],
      6     => [:group,       :close,         ')',      8,  9, 0],
    },

    '(?>a(?>b(?>c)))' => {
      0     => [:group,       :atomic,        '(?>',    0,  3, 0],
      2     => [:group,       :atomic,        '(?>',    4,  7, 1],
      4     => [:group,       :atomic,        '(?>',    8, 11, 2],
      6     => [:group,       :close,         ')',     12, 13, 2],
      7     => [:group,       :close,         ')',     13, 14, 1],
      8     => [:group,       :close,         ')',     14, 15, 0],
    },

    '(?:a(?:b(?:c)))' => {
      0     => [:group,       :passive,       '(?:',    0,  3, 0],
      2     => [:group,       :passive,       '(?:',    4,  7, 1],
      4     => [:group,       :passive,       '(?:',    8, 11, 2],
      6     => [:group,       :close,         ')',     12, 13, 2],
      7     => [:group,       :close,         ')',     13, 14, 1],
      8     => [:group,       :close,         ')',     14, 15, 0],
    },

    '(?=a(?!b(?<=c(?<!d))))' => {
      0     => [:assertion,   :lookahead,     '(?=',    0,  3, 0],
      2     => [:assertion,   :nlookahead,    '(?!',    4,  7, 1],
      4     => [:assertion,   :lookbehind,    '(?<=',   8, 12, 2],
      6     => [:assertion,   :nlookbehind,   '(?<!',  13, 17, 3],
      8     => [:group,       :close,         ')',     18, 19, 3],
      9     => [:group,       :close,         ')',     19, 20, 2],
      10    => [:group,       :close,         ')',     20, 21, 1],
      11    => [:group,       :close,         ')',     21, 22, 0],
    },

    '((?#a)b(?#c)d(?#e))' => {
      0     => [:group,       :capture,       '(',      0,  1, 0],
      1     => [:group,       :comment,       '(?#a)',  1,  6, 1],
      3     => [:group,       :comment,       '(?#c)',  7, 12, 1],
      5     => [:group,       :comment,       '(?#e)', 13, 18, 1],
      6     => [:group,       :close,         ')',     18, 19, 0],
    },

    'a[b-e]f' => {
      1     => [:set,         :open,          '[',      1,  2, 0],
      2     => [:set,         :range,         'b-e',    2,  5, 1],
      3     => [:set,         :close,         ']',      5,  6, 0],
    },

    '[a-w&&[^c-g]z]' => {
      0     => [:set,         :open,          '[',      0,  1, 0],
      2     => [:set,         :intersection,  '&&',     4,  6, 1],
      3     => [:set,         :open,          '[',      6,  7, 1],
      4     => [:set,         :negate,        '^',      7,  8, 2],
      5     => [:set,         :range,         'c-g',    8, 11, 2],
      6     => [:set,         :close,         ']',     11, 12, 1],
      8     => [:set,         :close,         ']',     13, 14, 0],
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
