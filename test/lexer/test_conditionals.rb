require File.expand_path("../../helpers", __FILE__)

class LexerConditionals < Test::Unit::TestCase

  if RUBY_VERSION >= '2.0'

  # Basic lexer output and nesting tests
  tests = {
    '(?<A>a)(?(<A>)b|c)'  => [ 3, :conditional, :open,             '(?',    7,  9, 0, 0, 0],
    '(?<B>a)(?(<B>)b|c)'  => [ 4, :conditional, :condition_open,   '(',     9, 10, 0, 0, 1],
    '(?<C>a)(?(<C>)b|c)'  => [ 5, :conditional, :condition,        '<C>',  10, 13, 0, 0, 1],
    '(?<D>a)(?(<D>)b|c)'  => [ 6, :conditional, :condition_close,  ')',    13, 14, 0, 0, 1],
    '(?<E>a)(?(<E>)b|c)'  => [ 8, :conditional, :separator,        '|',    15, 16, 0, 0, 1],
    '(?<F>a)(?(<F>)b|c)'  => [10, :conditional, :close,            ')',    17, 18, 0, 0, 0],
  }

  count = 0
  tests.each do |pattern, test|
    define_method "test_lexer_#{test[1]}_#{test[2]}_#{count+=1}" do
      tokens = RL.scan(pattern, 'ruby/2.0')
      assert_equal( test[1,8], tokens[test[0]].to_a)
    end
  end

  def test_lexer_conditional_mixed_nesting
    regexp = /((?<A>a)(?<B>(?(<A>)b|((?(<B>)[e-g]|[h-j])))))/
    tokens = RL.scan(regexp, 'ruby/2.0')

    expected = [
      [ 0, :group,       :capture,          '(',     0,  1, 0, 0, 0],
      [ 1, :group,       :named,            '(?<A>', 1,  6, 1, 0, 0],

      [ 5, :conditional, :open,             '(?',   13, 15, 2, 0, 0],
      [ 6, :conditional, :condition_open,   '(',    15, 16, 2, 0, 1],
      [ 7, :conditional, :condition,        '<A>',  16, 19, 2, 0, 1],
      [ 8, :conditional, :condition_close,  ')',    19, 20, 2, 0, 1],
      [10, :conditional, :separator,        '|',    21, 22, 2, 0, 1],

      [12, :conditional, :open,             '(?',   23, 25, 3, 0, 1],
      [13, :conditional, :condition_open,   '(',    25, 26, 3, 0, 2],
      [14, :conditional, :condition,        '<B>',  26, 29, 3, 0, 2],
      [15, :conditional, :condition_close,  ')',    29, 30, 3, 0, 2],

      [16, :set,         :open,             '[',    30, 31, 3, 0, 2],
      [17, :set,         :range,            'e-g',  31, 34, 3, 1, 2],
      [18, :set,         :close,            ']',    34, 35, 3, 0, 2],

      [19, :conditional, :separator,        '|',    35, 36, 3, 0, 2],
      [23, :conditional, :close,            ')',    41, 42, 3, 0, 1],
      [25, :conditional, :close,            ')',    43, 44, 2, 0, 0],

      [26, :group,       :close,            ')',    44, 45, 1, 0, 0],
      [27, :group,       :close,            ')',    45, 46, 0, 0, 0]
    ].each do |test|
      assert_equal( test[1,8], tokens[test[0]].to_a)
    end
  end

  def test_lexer_conditional_deep_nesting
    regexp = /(a(b(c)))(?(1)(?(2)(?(3)d|e))|(?(3)(?(2)f|g)|(?(1)f|g)))/
    tokens = RL.scan(regexp, 'ruby/2.0')

    expected = [
      [ 9, :conditional, :open,       '(?',    9, 11, 0, 0, 0],
      [11, :conditional, :condition,  '1',    12, 13, 0, 0, 1],

      [13, :conditional, :open,       '(?',   14, 16, 0, 0, 1],
      [15, :conditional, :condition,  '2',    17, 18, 0, 0, 2],

      [17, :conditional, :open,       '(?',   19, 21, 0, 0, 2],
      [19, :conditional, :condition,  '3',    22, 23, 0, 0, 3],

      [22, :conditional, :separator,  '|',    25, 26, 0, 0, 3],

      [24, :conditional, :close,      ')',    27, 28, 0, 0, 2],
      [25, :conditional, :close,      ')',    28, 29, 0, 0, 1],

      [26, :conditional, :separator,  '|',    29, 30, 0, 0, 1],

      [27, :conditional, :open,       '(?',   30, 32, 0, 0, 1],
      [29, :conditional, :condition,  '3',    33, 34, 0, 0, 2],

      [31, :conditional, :open,       '(?',   35, 37, 0, 0, 2],
      [33, :conditional, :condition,  '2',    38, 39, 0, 0, 3],

      [36, :conditional, :separator,  '|',    41, 42, 0, 0, 3],

      [38, :conditional, :close,      ')',    43, 44, 0, 0, 2],

      [39, :conditional, :separator,  '|',    44, 45, 0, 0, 2],

      [40, :conditional, :open,       '(?',   45, 47, 0, 0, 2],
      [42, :conditional, :condition,  '1',    48, 49, 0, 0, 3],

      [45, :conditional, :separator,  '|',    51, 52, 0, 0, 3],

      [47, :conditional, :close,      ')',    53, 54, 0, 0, 2],
      [48, :conditional, :close,      ')',    54, 55, 0, 0, 1],
      [49, :conditional, :close,      ')',    55, 56, 0, 0, 0]
    ].each do |test|
      assert_equal( test[1,8], tokens[test[0]].to_a)
    end
  end

  end

end
