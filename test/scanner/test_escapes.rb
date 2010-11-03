require File.expand_path("../../helpers", __FILE__)

class ScannerEscapes < Test::Unit::TestCase

  tests = {
    /c\at/          => [1, :escape,  :bell,           '\a',        2,  3],

    # TODO: figure this out: escape:backspace or anchor:word_boundary
    #/c\bt/          => [1, :escape,  :backspace,     '\b',      2, 3],

    /c\ft/          => [1, :escape,  :form_feed,      '\f',        2,  3],
    /c\nt/          => [1, :escape,  :newline,        '\n',        2,  3],
    /c\tt/          => [1, :escape,  :tab,            '\t',        2,  3],
    /c\vt/          => [1, :escape,  :vertical_tab,   '\v',        2,  3],

    /c\qt/          => [1, :escape,  :literal,        '\q',        2,  3],

    'a\012c'        => [1, :escape,  :octal,          '\012',      2,  5],
    'a\0124'        => [1, :escape,  :octal,          '\012',      2,  5],
    '\712+7'        => [0, :escape,  :octal,          '\712',      1,  4],

    'a\x24c'        => [1, :escape,  :hex,            '\x24',      2,  5],
    'a\x0640c'      => [1, :escape,  :hex,            '\x06',      2,  5],

    # TODO: figure out why this fails, not POSIX or Ruby, can wait
    #'a\x{0640}c'   => [1, :escape,  :hex,            '\x{0640}',  2,  8],

    'a\u0640c'        => [1, :escape,  :codepoint,      '\u0640',    2,  7],
    'a\u{0640 0641}c' => [1, :escape,  :codepoint_list, '\u{0640 0641}',  2,  14],

    'a\cCc'         => [1, :escape,  :control,        '\cC',       2,  4],
    'a\M-Cc'        => [1, :escape,  :meta,           '\M-C',      2,  5],

    # TODO: complete scanner
    #'a\M-\Ccc'      => [1, :escape,  :meta_escape,     '\M-\Cc',   2,  5],
  }

  count = 0
  tests.each do |pattern, test|
    define_method "test_scan_#{test[1]}_#{test[2]}_#{count+=1}" do

      tokens = RS.scan(pattern)
      token = tokens[test[0]]
      assert_equal( test[1,5], token )

    end
  end

end
