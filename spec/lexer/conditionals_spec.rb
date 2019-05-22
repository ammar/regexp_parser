require 'spec_helper'

RSpec.describe('Conditional lexing') do
  # Basic lexer output and nesting tests
  include_examples 'lex', '(?<A>a)(?(<A>)b|c)', 3, :conditional, :open,       '(?',     7,  9, 0, 0, 0
  include_examples 'lex', '(?<B>a)(?(<B>)b|c)', 4, :conditional, :condition,  '(<B>)',  9, 14, 0, 0, 1
  include_examples 'lex', '(?<C>a)(?(<C>)b|c)', 6, :conditional, :separator,  '|',     15, 16, 0, 0, 1
  include_examples 'lex', '(?<D>a)(?(<D>)b|c)', 8, :conditional, :close,      ')',     17, 18, 0, 0, 0

  describe('conditional mixed nesting') do
    let(:pattern) { '((?<A>a)(?<B>(?(<A>)b|((?(<B>)[e-g]|[h-j])))))' }

    include_examples 'lex token',  0, :group,       :capture,     '(',       0,  1, 0, 0, 0
    include_examples 'lex token',  1, :group,       :named,       '(?<A>',   1,  6, 1, 0, 0
    include_examples 'lex token',  5, :conditional, :open,        '(?',     13, 15, 2, 0, 0
    include_examples 'lex token',  6, :conditional, :condition,   '(<A>)',  15, 20, 2, 0, 1
    include_examples 'lex token',  8, :conditional, :separator,   '|',      21, 22, 2, 0, 1
    include_examples 'lex token', 10, :conditional, :open,        '(?',     23, 25, 3, 0, 1
    include_examples 'lex token', 11, :conditional, :condition,   '(<B>)',  25, 30, 3, 0, 2
    include_examples 'lex token', 12, :set,         :open,        '[',      30, 31, 3, 0, 2
    include_examples 'lex token', 13, :literal,     :literal,     'e',      31, 32, 3, 1, 2
    include_examples 'lex token', 14, :set,         :range,       '-',      32, 33, 3, 1, 2
    include_examples 'lex token', 15, :literal,     :literal,     'g',      33, 34, 3, 1, 2
    include_examples 'lex token', 16, :set,         :close,       ']',      34, 35, 3, 0, 2
    include_examples 'lex token', 17, :conditional, :separator,   '|',      35, 36, 3, 0, 2
    include_examples 'lex token', 23, :conditional, :close,       ')',      41, 42, 3, 0, 1
    include_examples 'lex token', 25, :conditional, :close,       ')',      43, 44, 2, 0, 0
    include_examples 'lex token', 26, :group,       :close,       ')',      44, 45, 1, 0, 0
    include_examples 'lex token', 27, :group,       :close,       ')',      45, 46, 0, 0, 0
  end

  describe('conditional deep nesting') do
    let(:pattern) { '(a(b(c)))(?(1)(?(2)(?(3)d|e))|(?(3)(?(2)f|g)|(?(1)f|g)))' }

    include_examples 'lex token',  9, :conditional, :open,       '(?',    9, 11, 0, 0, 0
    include_examples 'lex token', 10, :conditional, :condition,  '(1)',  11, 14, 0, 0, 1
    include_examples 'lex token', 11, :conditional, :open,       '(?',   14, 16, 0, 0, 1
    include_examples 'lex token', 12, :conditional, :condition,  '(2)',  16, 19, 0, 0, 2
    include_examples 'lex token', 13, :conditional, :open,       '(?',   19, 21, 0, 0, 2
    include_examples 'lex token', 14, :conditional, :condition,  '(3)',  21, 24, 0, 0, 3
    include_examples 'lex token', 16, :conditional, :separator,  '|',    25, 26, 0, 0, 3
    include_examples 'lex token', 18, :conditional, :close,      ')',    27, 28, 0, 0, 2
    include_examples 'lex token', 19, :conditional, :close,      ')',    28, 29, 0, 0, 1
    include_examples 'lex token', 20, :conditional, :separator,  '|',    29, 30, 0, 0, 1
    include_examples 'lex token', 21, :conditional, :open,       '(?',   30, 32, 0, 0, 1
    include_examples 'lex token', 22, :conditional, :condition,  '(3)',  32, 35, 0, 0, 2
    include_examples 'lex token', 23, :conditional, :open,       '(?',   35, 37, 0, 0, 2
    include_examples 'lex token', 24, :conditional, :condition,  '(2)',  37, 40, 0, 0, 3
    include_examples 'lex token', 26, :conditional, :separator,  '|',    41, 42, 0, 0, 3
    include_examples 'lex token', 28, :conditional, :close,      ')',    43, 44, 0, 0, 2
    include_examples 'lex token', 29, :conditional, :separator,  '|',    44, 45, 0, 0, 2
    include_examples 'lex token', 30, :conditional, :open,       '(?',   45, 47, 0, 0, 2
    include_examples 'lex token', 31, :conditional, :condition,  '(1)',  47, 50, 0, 0, 3
    include_examples 'lex token', 33, :conditional, :separator,  '|',    51, 52, 0, 0, 3
    include_examples 'lex token', 35, :conditional, :close,      ')',    53, 54, 0, 0, 2
    include_examples 'lex token', 36, :conditional, :close,      ')',    54, 55, 0, 0, 1
    include_examples 'lex token', 37, :conditional, :close,      ')',    55, 56, 0, 0, 0
  end
end
