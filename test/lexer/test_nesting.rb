require File.expand_path("../../helpers", __FILE__)

class LexerNesting < Test::Unit::TestCase

  tests = {
    '(((b)))' => {
      0     => [:group,       :capture,       '(',      0,  1, 0, 0, 0],
      1     => [:group,       :capture,       '(',      1,  2, 1, 0, 0],
      2     => [:group,       :capture,       '(',      2,  3, 2, 0, 0],
      3     => [:literal,     :literal,       'b',      3,  4, 3, 0, 0],
      4     => [:group,       :close,         ')',      4,  5, 2, 0, 0],
      5     => [:group,       :close,         ')',      5,  6, 1, 0, 0],
      6     => [:group,       :close,         ')',      6,  7, 0, 0, 0],
    },

    '(\((b)\))' => {
      0     => [:group,       :capture,       '(',      0,  1, 0, 0, 0],
      1     => [:escape,      :group_open,    '\(',     1,  3, 1, 0, 0],
      2     => [:group,       :capture,       '(',      3,  4, 1, 0, 0],
      3     => [:literal,     :literal,       'b',      4,  5, 2, 0, 0],
      4     => [:group,       :close,         ')',      5,  6, 1, 0, 0],
      5     => [:escape,      :group_close,   '\)',     6,  8, 1, 0, 0],
      6     => [:group,       :close,         ')',      8,  9, 0, 0, 0],
    },

    '(?>a(?>b(?>c)))' => {
      0     => [:group,       :atomic,        '(?>',    0,  3, 0, 0, 0],
      2     => [:group,       :atomic,        '(?>',    4,  7, 1, 0, 0],
      4     => [:group,       :atomic,        '(?>',    8, 11, 2, 0, 0],
      6     => [:group,       :close,         ')',     12, 13, 2, 0, 0],
      7     => [:group,       :close,         ')',     13, 14, 1, 0, 0],
      8     => [:group,       :close,         ')',     14, 15, 0, 0, 0],
    },

    '(?:a(?:b(?:c)))' => {
      0     => [:group,       :passive,       '(?:',    0,  3, 0, 0, 0],
      2     => [:group,       :passive,       '(?:',    4,  7, 1, 0, 0],
      4     => [:group,       :passive,       '(?:',    8, 11, 2, 0, 0],
      6     => [:group,       :close,         ')',     12, 13, 2, 0, 0],
      7     => [:group,       :close,         ')',     13, 14, 1, 0, 0],
      8     => [:group,       :close,         ')',     14, 15, 0, 0, 0],
    },

    '(?=a(?!b(?<=c(?<!d))))' => {
      0     => [:assertion,   :lookahead,     '(?=',    0,  3, 0, 0, 0],
      2     => [:assertion,   :nlookahead,    '(?!',    4,  7, 1, 0, 0],
      4     => [:assertion,   :lookbehind,    '(?<=',   8, 12, 2, 0, 0],
      6     => [:assertion,   :nlookbehind,   '(?<!',  13, 17, 3, 0, 0],
      8     => [:group,       :close,         ')',     18, 19, 3, 0, 0],
      9     => [:group,       :close,         ')',     19, 20, 2, 0, 0],
      10    => [:group,       :close,         ')',     20, 21, 1, 0, 0],
      11    => [:group,       :close,         ')',     21, 22, 0, 0, 0],
    },

    '((?#a)b(?#c)d(?#e))' => {
      0     => [:group,       :capture,       '(',      0,  1, 0, 0, 0],
      1     => [:group,       :comment,       '(?#a)',  1,  6, 1, 0, 0],
      3     => [:group,       :comment,       '(?#c)',  7, 12, 1, 0, 0],
      5     => [:group,       :comment,       '(?#e)', 13, 18, 1, 0, 0],
      6     => [:group,       :close,         ')',     18, 19, 0, 0, 0],
    },

    'a[b-e]f' => {
      1     => [:set,         :open,          '[',      1,  2, 0, 0, 0],
      2     => [:set,         :range,         'b-e',    2,  5, 0, 1, 0],
      3     => [:set,         :close,         ']',      5,  6, 0, 0, 0],
    },

    '[a-w&&[^c-g]z]' => {
      0     => [:set,         :open,          '[',      0,  1, 0, 0, 0],
      2     => [:set,         :intersection,  '&&',     4,  6, 0, 1, 0],
      3     => [:subset,      :open,          '[',      6,  7, 0, 1, 0],
      4     => [:subset,      :negate,        '^',      7,  8, 0, 2, 0],
      5     => [:subset,      :range,         'c-g',    8, 11, 0, 2, 0],
      6     => [:subset,      :close,         ']',     11, 12, 0, 1, 0],
      8     => [:set,         :close,         ']',     13, 14, 0, 0, 0],
    },

    '[a[b[c[d-g]]]]' => {
      0     => [:set,         :open,          '[',      0,  1, 0, 0, 0],
      1     => [:set,         :member,        'a',      1,  2, 0, 1, 0],
      2     => [:subset,      :open,          '[',      2,  3, 0, 1, 0],
      3     => [:subset,      :member,        'b',      3,  4, 0, 2, 0],
      4     => [:subset,      :open,          '[',      4,  5, 0, 2, 0],
      5     => [:subset,      :member,        'c',      5,  6, 0, 3, 0],
      6     => [:subset,      :open,          '[',      6,  7, 0, 3, 0],
      7     => [:subset,      :range,         'd-g',    7, 10, 0, 4, 0],
      8     => [:subset,      :close,         ']',     10, 11, 0, 3, 0],
      9     => [:subset,      :close,         ']',     11, 12, 0, 2, 0],
     10     => [:subset,      :close,         ']',     12, 13, 0, 1, 0],
     11     => [:set,         :close,         ']',     13, 14, 0, 0, 0],
    },
  }

  tests.each_with_index do |(pattern, checks), count|
    define_method "test_lex_nesting_#{count}" do
      tokens = RL.lex(pattern, 'ruby/1.9')

      checks.each do |offset, (type, token, text, ts, te, level, set_level, conditional_level)|
        struct = tokens.at(offset)

        assert_equal type,              struct.type
        assert_equal token,             struct.token
        assert_equal text,              struct.text
        assert_equal ts,                struct.ts
        assert_equal te,                struct.te
        assert_equal level,             struct.level
        assert_equal set_level,         struct.set_level
        assert_equal conditional_level, struct.conditional_level
      end
    end
  end

end
