require File.expand_path("../../helpers", __FILE__)

class ScannerEscapes < Test::Unit::TestCase

  tests = {
    /c\at/            => [1, :escape,  :bell,             '\a',             1,  3],

    # not an escape outside a character set
    /c\bt/            => [1, :anchor,  :word_boundary,    '\b',             1, 3],

    /c\ft/            => [1, :escape,  :form_feed,        '\f',             1,  3],
    /c\nt/            => [1, :escape,  :newline,          '\n',             1,  3],
    /c\tt/            => [1, :escape,  :tab,              '\t',             1,  3],
    /c\vt/            => [1, :escape,  :vertical_tab,     '\v',             1,  3],

    'c\qt'            => [1, :escape,  :literal,          '\q',             1,  3],

    'a\012c'          => [1, :escape,  :octal,            '\012',           1,  5],
    'a\0124'          => [1, :escape,  :octal,            '\012',           1,  5],
    '\712+7'          => [0, :escape,  :octal,            '\712',           0,  4],

    'a\x24c'          => [1, :escape,  :hex,              '\x24',           1,  5],
    'a\x0640c'        => [1, :escape,  :hex,              '\x06',           1,  5],

    'a\x{0640}c'      => [1, :escape,  :hex_wide,         '\x{0640}',       1,  9],

    'a\u0640c'        => [1, :escape,  :codepoint,        '\u0640',         1,  7],
    'a\u{640 0641}c'  => [1, :escape,  :codepoint_list,   '\u{640 0641}',   1,  13],

    /a\cBc/           => [1, :escape,  :control,          '\cB',            1,  4],
    /a\C-bc/          => [1, :escape,  :control,          '\C-b',           1,  5],
    /a\c\M-Bc/n       => [1, :escape,  :control,          '\c\M-B',         1,  7],
    /a\C-\M-Bc/n      => [1, :escape,  :control,          '\C-\M-B',        1,  8],

    /a\M-Bc/n         => [1, :escape,  :meta_sequence,    '\M-B',           1,  5],
    /a\M-\C-Bc/n      => [1, :escape,  :meta_sequence,    '\M-\C-B',        1,  8],
    /a\M-\cBc/n       => [1, :escape,  :meta_sequence,    '\M-\cB',         1,  7],

    'ab\\\xcd'        => [1, :escape,  :backslash,        '\\\\',           2,  4],
    'ab\\\0cd'        => [1, :escape,  :backslash,        '\\\\',           2,  4],
    'ab\\\Kcd'        => [1, :escape,  :backslash,        '\\\\',           2,  4],
  }

  tests.each_with_index do |(pattern, (index, type, token, text, ts, te)), count|
    define_method "test_scanner_#{type}_#{token}_#{count}" do
      tokens = RS.scan(pattern)
      result = tokens.at(index)

      assert_equal type,  result[0]
      assert_equal token, result[1]
      assert_equal text,  result[2]
      assert_equal ts,    result[3]
      assert_equal te,    result[4]
    end
  end

end
