# encoding: utf-8

require File.expand_path("../../helpers", __FILE__)

class ScannerSets < Test::Unit::TestCase

  tests = {
    '[a]'                   => [0, :set,    :open,            '[',          0, 1],
    '[b]'                   => [2, :set,    :close,           ']',          2, 3],
    '[^n]'                  => [1, :set,    :negate,          '^',          1, 2],

    '[c]'                   => [1, :literal, :literal,        'c',          1, 2],
    '[\b]'                  => [1, :escape,  :backspace,      '\b',         1, 3],
    '[A\bX]'                => [2, :escape,  :backspace,      '\b',         2, 4],

    '[.]'                   => [1, :literal, :literal,        '.',          1, 2],
    '[?]'                   => [1, :literal, :literal,        '?',          1, 2],
    '[*]'                   => [1, :literal, :literal,        '*',          1, 2],
    '[+]'                   => [1, :literal, :literal,        '+',          1, 2],
    '[{]'                   => [1, :literal, :literal,        '{',          1, 2],
    '[}]'                   => [1, :literal, :literal,        '}',          1, 2],
    '[<]'                   => [1, :literal, :literal,        '<',          1, 2],
    '[>]'                   => [1, :literal, :literal,        '>',          1, 2],

    '[äöü]'                 => [2, :literal, :literal,        'ö',          3, 5],

    '[\x20]'                => [1, :escape, :hex,             '\x20',       1, 5],

    '[\.]'                  => [1, :escape, :dot,             '\.',         1, 3],
    '[\!]'                  => [1, :escape, :literal,         '\!',         1, 3],
    '[\#]'                  => [1, :escape, :literal,         '\#',         1, 3],
    '[\]]'                  => [1, :escape, :set_close,       '\]',         1, 3],
    '[\\\]'                 => [1, :escape, :backslash,       '\\\\',       1, 3],
    '[\A]'                  => [1, :escape, :literal,         '\A',         1, 3],
    '[\z]'                  => [1, :escape, :literal,         '\z',         1, 3],
    '[\g]'                  => [1, :escape, :literal,         '\g',         1, 3],
    '[\K]'                  => [1, :escape, :literal,         '\K',         1, 3],
    '[\c2]'                 => [1, :escape, :literal,         '\c',         1, 3],
    '[\B]'                  => [1, :escape, :literal,         '\B',         1, 3],
    '[a\-c]'                => [2, :escape, :literal,         '\-',         2, 4],

    '[\d]'                  => [1, :type,   :digit,           '\d',         1, 3],
    '[\da-z]'               => [1, :type,   :digit,           '\d',         1, 3],
    '[\D]'                  => [1, :type,   :nondigit,        '\D',         1, 3],

    '[\h]'                  => [1, :type,   :hex,             '\h',         1, 3],
    '[\H]'                  => [1, :type,   :nonhex,          '\H',         1, 3],

    '[\s]'                  => [1, :type,   :space,           '\s',         1, 3],
    '[\S]'                  => [1, :type,   :nonspace,        '\S',         1, 3],

    '[\w]'                  => [1, :type,   :word,            '\w',         1, 3],
    '[\W]'                  => [1, :type,   :nonword,         '\W',         1, 3],

    '[\R]'                  => [1, :escape, :literal,         '\R',         1, 3],
    '[\X]'                  => [1, :escape, :literal,         '\X',         1, 3],

    '[a-b]'                 => [1, :literal, :literal,        'a',          1, 2],
    '[a-c]'                 => [2, :set,     :range,          '-',          2, 3],
    '[a-d]'                 => [3, :literal, :literal,        'd',          3, 4],
    '[a-b-]'                => [4, :literal, :literal,        '-',          4, 6],
    '[-a]'                  => [1, :literal, :literal,        '-',          1, 2],
    '[a-c^]'                => [4, :literal, :literal,        '^',          4, 5],
    '[a-bd-f]'              => [2, :set,    :range,           '-',          2, 3],
    '[a-cd-f]'              => [5, :set,    :range,           '-',          5, 6],

    '[a[:digit:]c]'         => [2, :posixclass,    :digit,    '[:digit:]',  2, 11],
    '[[:digit:][:space:]]'  => [2, :posixclass,    :space,    '[:space:]', 10, 19],
    '[[:^digit:]]'          => [1, :nonposixclass, :digit,    '[:^digit:]', 1, 11],

    '[a[.a-b.]c]'           => [2, :set,    :collation,       '[.a-b.]',    2,  9],
    '[a[=e=]c]'             => [2, :set,    :equivalent,      '[=e=]',      2,  7],

    '[a-d&&g-h]'            => [4, :set,    :intersection,    '&&',         4, 6],
    '[a&&]'                 => [2, :set,    :intersection,    '&&',         2, 4],
    '[&&z]'                 => [1, :set,    :intersection,    '&&',         1, 3],

    '[\\x20-\\x27]'         => [1, :escape, :hex,             '\x20',       1, 5],
    '[\\x20-\\x28]'         => [2, :set,    :range,           '-',          5, 6],
    '[\\x20-\\x29]'         => [3, :escape, :hex,             '\x29',       6, 10],

    '[a\p{digit}c]'         => [2, :property,    :digit,      '\p{digit}',  2, 11],
    '[a\P{digit}c]'         => [2, :nonproperty, :digit,      '\P{digit}',  2, 11],
    '[a\p{^digit}c]'        => [2, :nonproperty, :digit,      '\p{^digit}', 2, 12],
    '[a\P{^digit}c]'        => [2, :property,    :digit,      '\P{^digit}', 2, 12],

    '[a\p{ALPHA}c]'         => [2, :property,    :alpha,      '\p{ALPHA}',  2, 11],
    '[a\p{P}c]'             => [2, :property,    :punctuation,'\p{P}',      2, 7],
    '[a\p{P}\P{P}c]'        => [3, :nonproperty, :punctuation,'\P{P}',      7, 12],

    '[a-w&&[^c-g]z]'        => [5, :set,    :open,            '[',          6, 7],
    '[a-w&&[^c-h]z]'        => [6, :set,    :negate,          '^',          7, 8],
    '[a-w&&[^c-i]z]'        => [8, :set,    :range,           '-',          9, 10],
    '[a-w&&[^c-j]z]'        => [10,:set,    :close,           ']',          11, 12],
  }

  tests.each_with_index do |(pattern, (index, type, token, text, ts, te)), count|
    define_method "test_scanner_#{type}_#{token}_in_'#{pattern}'_#{count}" do
      tokens = RS.scan(pattern)
      result = tokens.at(index)

      assert_equal type,  result[0]
      assert_equal token, result[1]
      assert_equal text,  result[2]
      assert_equal ts,    result[3]
      assert_equal te,    result[4]
    end
  end

  def test_set_literal_encoding
    text = RS.scan('[a]')[1][2].to_s
    assert_equal 'a',     text
    assert_equal 'UTF-8', text.encoding.to_s

    text = RS.scan('[😲]')[1][2].to_s
    assert_equal '😲',     text
    assert_equal 'UTF-8', text.encoding.to_s
  end
end
