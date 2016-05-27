require File.expand_path("../../helpers", __FILE__)

class ScannerFreeSpace < Test::Unit::TestCase

  def test_scan_free_space_tokens
    regexp = %r{
      a
      b  ?  c  *
      d  {2,3}
      e + | f +
    }x

    tokens = RS.scan(regexp)

    0.upto(24) do |i|
      if i.even?
        assert_equal :free_space, tokens[i][0]
        assert_equal :whitespace, tokens[i][1]
      else
        refute_equal :free_space, tokens[i][0]
        refute_equal :whitespace, tokens[i][1]
      end
    end

    [0, 2, 10, 14].each do |i|
      assert_equal "\n      ",   tokens[i][2]
    end

    [4, 6, 8, 12].each do |i|
      assert_equal '  ',         tokens[i][2]
    end
  end

  def test_scan_free_space_comments
    regexp = %r{
      a + # A + comment
      b  ?  # B ? comment
      c  {2,3} # C {2,3} comment
      d + | e + # D|E comment
    }x

    tokens = RS.scan(regexp)

    [
      [ 5, :free_space, :comment,  "# A + comment\n",      11,  25],
      [11, :free_space, :comment,  "# B ? comment\n",      37,  51],
      [17, :free_space, :comment,  "# C {2,3} comment\n",  66,  84],
      [29, :free_space, :comment,  "# D|E comment\n",     100, 114],
    ].each do |index, type, token, text, ts, te|
      result = tokens[index]

      assert_equal type,  result[0]
      assert_equal token, result[1]
      assert_equal text,  result[2]
      assert_equal ts,    result[3]
      assert_equal te,    result[4]
    end
  end

  def test_scan_free_space_inlined
    # Matches 'a bcdef g'
    regexp = /a b(?x:c d e)f g/
    tokens = RS.scan(regexp)

    [
      [0, :literal,    :literal,     'a b',   0,  3],
      [1, :group,      :options,     '(?x:',  3,  7],
      [2, :literal,    :literal,     'c',     7,  8],
      [3, :free_space, :whitespace,  ' ',     8,  9],
      [4, :literal,    :literal,     'd',     9, 10],
      [5, :free_space, :whitespace,  ' ',    10, 11],
      [6, :literal,    :literal,     'e',    11, 12],
      [7, :group,      :close,       ')',    12, 13],
      [8, :literal,    :literal,     'f g',  13, 16]
    ].each do |index, type, token, text, ts, te|
      result = tokens[index]

      assert_equal type,  result[0]
      assert_equal token, result[1]
      assert_equal text,  result[2]
      assert_equal ts,    result[3]
      assert_equal te,    result[4]
    end
  end

  def test_scan_free_space_nested
    # Matches 'a bcde fghi j'
    regexp = /a b(?x:c d(?-x:e f)g h)i j/
    tokens = RS.scan(regexp)

    [
      [ 0, :literal,     :literal,     'a b',     0,  3],
      [ 1, :group,       :options,     '(?x:',    3,  7],
      [ 2, :literal,     :literal,     'c',       7,  8],
      [ 3, :free_space,  :whitespace,  ' ',       8,  9],
      [ 4, :literal,     :literal,     'd',       9, 10],
      [ 5, :group,       :options,     '(?-x:',  10, 15],
      [ 6, :literal,     :literal,     'e f',    15, 18],
      [ 7, :group,       :close,       ')',      18, 19],
      [ 8, :literal,     :literal,     'g',      19, 20],
      [ 9, :free_space,  :whitespace,  ' ',      20, 21],
      [10, :literal,     :literal,     'h',      21, 22],
      [11, :group,       :close,       ')',      22, 23],
      [12, :literal,     :literal,     'i j',    23, 26]
    ].each do |index, type, token, text, ts, te|
      result = tokens[index]

      assert_equal type,  result[0]
      assert_equal token, result[1]
      assert_equal text,  result[2]
      assert_equal ts,    result[3]
      assert_equal te,    result[4]
    end
  end

  def test_scan_free_space_nested_groups
    # Matches 'a bcde f g hi j'
    regexp = /(a (b(?x: (c d) (?-x:(e f) )g) h)i j)/
    tokens = RS.scan(regexp)

    [
      [ 0, :group,       :capture,     '(',       0,  1],
      [ 1, :literal,     :literal,     'a ',      1,  3],
      [ 2, :group,       :capture,     '(',       3,  4],
      [ 3, :literal,     :literal,     'b',       4,  5],
      [ 4, :group,       :options,     '(?x:',    5,  9],
      [ 5, :free_space,  :whitespace,  ' ',       9, 10],
      [ 6, :group,       :capture,     '(',      10, 11],
      [ 7, :literal,     :literal,     'c',      11, 12],
      [ 8, :free_space,  :whitespace,  ' ',      12, 13],
      [ 9, :literal,     :literal,     'd',      13, 14],
      [10, :group,       :close,       ')',      14, 15],
      [11, :free_space,  :whitespace,  ' ',      15, 16],
      [12, :group,       :options,     '(?-x:',  16, 21],
      [13, :group,       :capture,     '(',      21, 22],
      [14, :literal,     :literal,     'e f',    22, 25],
      [15, :group,       :close,       ')',      25, 26],
      [16, :literal,     :literal,     ' ',      26, 27],
      [17, :group,       :close,       ')',      27, 28],
      [18, :literal,     :literal,     'g',      28, 29],
      [19, :group,       :close,       ')',      29, 30],
      [20, :literal,     :literal,     ' h',     30, 32],
      [21, :group,       :close,       ')',      32, 33],
      [22, :literal,     :literal,     'i j',    33, 36],
      [23, :group,       :close,       ')',      36, 37]
    ].each do |index, type, token, text, ts, te|
      result = tokens[index]

      assert_equal type,  result[0]
      assert_equal token, result[1]
      assert_equal text,  result[2]
      assert_equal ts,    result[3]
      assert_equal te,    result[4]
    end
  end

end
