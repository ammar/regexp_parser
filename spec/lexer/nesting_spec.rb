require 'spec_helper'

RSpec.describe('Nesting lexing') do
  include_examples 'lex', '(((b)))', 0,   :group,       :capture,       '(',      0,  1, 0, 0, 0
  include_examples 'lex', '(((b)))', 1,   :group,       :capture,       '(',      1,  2, 1, 0, 0
  include_examples 'lex', '(((b)))', 2,   :group,       :capture,       '(',      2,  3, 2, 0, 0
  include_examples 'lex', '(((b)))', 3,   :literal,     :literal,       'b',      3,  4, 3, 0, 0
  include_examples 'lex', '(((b)))', 4,   :group,       :close,         ')',      4,  5, 2, 0, 0
  include_examples 'lex', '(((b)))', 5,   :group,       :close,         ')',      5,  6, 1, 0, 0
  include_examples 'lex', '(((b)))', 6,   :group,       :close,         ')',      6,  7, 0, 0, 0

  include_examples 'lex', '(\((b)\))', 0,   :group,       :capture,       '(',      0,  1, 0, 0, 0
  include_examples 'lex', '(\((b)\))', 1,   :escape,      :group_open,    '\(',     1,  3, 1, 0, 0
  include_examples 'lex', '(\((b)\))', 2,   :group,       :capture,       '(',      3,  4, 1, 0, 0
  include_examples 'lex', '(\((b)\))', 3,   :literal,     :literal,       'b',      4,  5, 2, 0, 0
  include_examples 'lex', '(\((b)\))', 4,   :group,       :close,         ')',      5,  6, 1, 0, 0
  include_examples 'lex', '(\((b)\))', 5,   :escape,      :group_close,   '\)',     6,  8, 1, 0, 0
  include_examples 'lex', '(\((b)\))', 6,   :group,       :close,         ')',      8,  9, 0, 0, 0

  include_examples 'lex', '(?>a(?>b(?>c)))', 0,   :group,       :atomic,        '(?>',    0,  3, 0, 0, 0
  include_examples 'lex', '(?>a(?>b(?>c)))', 2,   :group,       :atomic,        '(?>',    4,  7, 1, 0, 0
  include_examples 'lex', '(?>a(?>b(?>c)))', 4,   :group,       :atomic,        '(?>',    8, 11, 2, 0, 0
  include_examples 'lex', '(?>a(?>b(?>c)))', 6,   :group,       :close,         ')',     12, 13, 2, 0, 0
  include_examples 'lex', '(?>a(?>b(?>c)))', 7,   :group,       :close,         ')',     13, 14, 1, 0, 0
  include_examples 'lex', '(?>a(?>b(?>c)))', 8,   :group,       :close,         ')',     14, 15, 0, 0, 0

  include_examples 'lex', '(?:a(?:b(?:c)))', 0,   :group,       :passive,       '(?:',    0,  3, 0, 0, 0
  include_examples 'lex', '(?:a(?:b(?:c)))', 2,   :group,       :passive,       '(?:',    4,  7, 1, 0, 0
  include_examples 'lex', '(?:a(?:b(?:c)))', 4,   :group,       :passive,       '(?:',    8, 11, 2, 0, 0
  include_examples 'lex', '(?:a(?:b(?:c)))', 6,   :group,       :close,         ')',     12, 13, 2, 0, 0
  include_examples 'lex', '(?:a(?:b(?:c)))', 7,   :group,       :close,         ')',     13, 14, 1, 0, 0
  include_examples 'lex', '(?:a(?:b(?:c)))', 8,   :group,       :close,         ')',     14, 15, 0, 0, 0

  include_examples 'lex', '(?=a(?!b(?<=c(?<!d))))', 0,   :assertion,   :lookahead,     '(?=',    0,  3, 0, 0, 0
  include_examples 'lex', '(?=a(?!b(?<=c(?<!d))))', 2,   :assertion,   :nlookahead,    '(?!',    4,  7, 1, 0, 0
  include_examples 'lex', '(?=a(?!b(?<=c(?<!d))))', 4,   :assertion,   :lookbehind,    '(?<=',   8, 12, 2, 0, 0
  include_examples 'lex', '(?=a(?!b(?<=c(?<!d))))', 6,   :assertion,   :nlookbehind,   '(?<!',  13, 17, 3, 0, 0
  include_examples 'lex', '(?=a(?!b(?<=c(?<!d))))', 8,   :group,       :close,         ')',     18, 19, 3, 0, 0
  include_examples 'lex', '(?=a(?!b(?<=c(?<!d))))', 9,   :group,       :close,         ')',     19, 20, 2, 0, 0
  include_examples 'lex', '(?=a(?!b(?<=c(?<!d))))', 10,  :group,       :close,         ')',     20, 21, 1, 0, 0
  include_examples 'lex', '(?=a(?!b(?<=c(?<!d))))', 11,  :group,       :close,         ')',     21, 22, 0, 0, 0

  include_examples 'lex', '((?#a)b(?#c)d(?#e))', 0,   :group,       :capture,       '(',      0,  1, 0, 0, 0
  include_examples 'lex', '((?#a)b(?#c)d(?#e))', 1,   :group,       :comment,       '(?#a)',  1,  6, 1, 0, 0
  include_examples 'lex', '((?#a)b(?#c)d(?#e))', 3,   :group,       :comment,       '(?#c)',  7, 12, 1, 0, 0
  include_examples 'lex', '((?#a)b(?#c)d(?#e))', 5,   :group,       :comment,       '(?#e)', 13, 18, 1, 0, 0
  include_examples 'lex', '((?#a)b(?#c)d(?#e))', 6,   :group,       :close,         ')',     18, 19, 0, 0, 0

  include_examples 'lex', 'a[b-e]f', 1,   :set,         :open,          '[',      1,  2, 0, 0, 0
  include_examples 'lex', 'a[b-e]f', 2,   :literal,     :literal,       'b',      2,  3, 0, 1, 0
  include_examples 'lex', 'a[b-e]f', 3,   :set,         :range,         '-',      3,  4, 0, 1, 0
  include_examples 'lex', 'a[b-e]f', 4,   :literal,     :literal,       'e',      4,  5, 0, 1, 0
  include_examples 'lex', 'a[b-e]f', 5,   :set,         :close,         ']',      5,  6, 0, 0, 0

  include_examples 'lex', '[[:word:]&&[^c]z]', 0,   :set,         :open,          '[',      0,  1, 0, 0, 0
  include_examples 'lex', '[[:word:]&&[^c]z]', 1,   :posixclass,  :word, '[:word:]',        1,  9, 0, 1, 0
  include_examples 'lex', '[[:word:]&&[^c]z]', 2,   :set,         :intersection,  '&&',     9, 11, 0, 1, 0
  include_examples 'lex', '[[:word:]&&[^c]z]', 3,   :set,         :open,          '[',     11, 12, 0, 1, 0
  include_examples 'lex', '[[:word:]&&[^c]z]', 4,   :set,         :negate,        '^',     12, 13, 0, 2, 0
  include_examples 'lex', '[[:word:]&&[^c]z]', 5,   :literal,     :literal,       'c',     13, 14, 0, 2, 0
  include_examples 'lex', '[[:word:]&&[^c]z]', 6,   :set,         :close,         ']',     14, 15, 0, 1, 0
  include_examples 'lex', '[[:word:]&&[^c]z]', 7,   :literal,     :literal,       'z',     15, 16, 0, 1, 0
  include_examples 'lex', '[[:word:]&&[^c]z]', 8,   :set,         :close,         ']',     16, 17, 0, 0, 0

  include_examples 'lex', '[\p{word}&&[^c]z]', 0,   :set,         :open,          '[',      0,  1, 0, 0, 0
  include_examples 'lex', '[\p{word}&&[^c]z]', 1,   :property,    :word, '\p{word}',        1,  9, 0, 1, 0
  include_examples 'lex', '[\p{word}&&[^c]z]', 2,   :set,         :intersection,  '&&',     9, 11, 0, 1, 0
  include_examples 'lex', '[\p{word}&&[^c]z]', 3,   :set,         :open,          '[',     11, 12, 0, 1, 0
  include_examples 'lex', '[\p{word}&&[^c]z]', 4,   :set,         :negate,        '^',     12, 13, 0, 2, 0
  include_examples 'lex', '[\p{word}&&[^c]z]', 5,   :literal,     :literal,       'c',     13, 14, 0, 2, 0
  include_examples 'lex', '[\p{word}&&[^c]z]', 6,   :set,         :close,         ']',     14, 15, 0, 1, 0
  include_examples 'lex', '[\p{word}&&[^c]z]', 7,   :literal,     :literal,       'z',     15, 16, 0, 1, 0
  include_examples 'lex', '[\p{word}&&[^c]z]', 8,   :set,         :close,         ']',     16, 17, 0, 0, 0

  include_examples 'lex', '[a[b[c[d-g]]]]', 0,   :set,         :open,          '[',      0,  1, 0, 0, 0
  include_examples 'lex', '[a[b[c[d-g]]]]', 1,   :literal,     :literal,       'a',      1,  2, 0, 1, 0
  include_examples 'lex', '[a[b[c[d-g]]]]', 2,   :set,         :open,          '[',      2,  3, 0, 1, 0
  include_examples 'lex', '[a[b[c[d-g]]]]', 3,   :literal,     :literal,       'b',      3,  4, 0, 2, 0
  include_examples 'lex', '[a[b[c[d-g]]]]', 4,   :set,         :open,          '[',      4,  5, 0, 2, 0
  include_examples 'lex', '[a[b[c[d-g]]]]', 5,   :literal,     :literal,       'c',      5,  6, 0, 3, 0
  include_examples 'lex', '[a[b[c[d-g]]]]', 6,   :set,         :open,          '[',      6,  7, 0, 3, 0
  include_examples 'lex', '[a[b[c[d-g]]]]', 7,   :literal,     :literal,       'd',      7,  8, 0, 4, 0
  include_examples 'lex', '[a[b[c[d-g]]]]', 8,   :set,         :range,         '-',      8,  9, 0, 4, 0
  include_examples 'lex', '[a[b[c[d-g]]]]', 9,   :literal,     :literal,       'g',      9, 10, 0, 4, 0
  include_examples 'lex', '[a[b[c[d-g]]]]', 10,  :set,         :close,         ']',     10, 11, 0, 3, 0
  include_examples 'lex', '[a[b[c[d-g]]]]', 11,  :set,         :close,         ']',     11, 12, 0, 2, 0
  include_examples 'lex', '[a[b[c[d-g]]]]', 12,  :set,         :close,         ']',     12, 13, 0, 1, 0
  include_examples 'lex', '[a[b[c[d-g]]]]', 13,  :set,         :close,         ']',     13, 14, 0, 0, 0
end
