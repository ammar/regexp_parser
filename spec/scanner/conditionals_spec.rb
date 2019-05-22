require 'spec_helper'

RSpec.describe('Conditional scanning') do
  include_examples 'scan', '(a)(?(1)T|F)1',       3,  :conditional,  :open,            '(?',  3,  5
  include_examples 'scan', '(a)(?(1)T|F)2',       4,  :conditional,  :condition_open,  '(',   5,  6
  include_examples 'scan', '(a)(?(1)T|F)3',       5,  :conditional,  :condition,       '1',   6,  7
  include_examples 'scan', '(a)(?(1)T|F)4',       6,  :conditional,  :condition_close, ')',   7,  8
  include_examples 'scan', '(a)(?(1)T|F)5',       7,  :literal,      :literal,         'T',   8,  9
  include_examples 'scan', '(a)(?(1)T|F)6',       8,  :conditional,  :separator,       '|',   9,  10
  include_examples 'scan', '(a)(?(1)T|F)7',       9,  :literal,      :literal,         'F',   10, 11
  include_examples 'scan', '(a)(?(1)T|F)8',       10, :conditional,  :close,           ')',   11, 12
  include_examples 'scan', '(a)(?(1)TRUE)9',      8,  :conditional,  :close,           ')',   12, 13
  include_examples 'scan', '(a)(?(1)TRUE|)10',    8,  :conditional,  :separator,       '|',   12, 13
  include_examples 'scan', '(a)(?(1)TRUE|)11',    9,  :conditional,  :close,           ')',   13, 14
  include_examples 'scan', '(?<N>A)(?(<N>)T|F)1', 5,  :conditional,  :condition,       '<N>', 10, 13
  include_examples 'scan', "(?'N'A)(?('N')T|F)2", 5,  :conditional,  :condition,       "'N'", 10, 13

  describe('scan conditional nested') do
    let(:tokens) { RS.scan('(a(b(c)))(?(1)(?(2)d|(?(3)e|f))|(?(2)(?(1)g|h)))') }

    include_examples 'scan token',  0, :group,        :capture,         '(',   0,  1
    include_examples 'scan token',  1, :literal,      :literal,         'a',   1,  2
    include_examples 'scan token',  2, :group,        :capture,         '(',   2,  3
    include_examples 'scan token',  3, :literal,      :literal,         'b',   3,  4
    include_examples 'scan token',  4, :group,        :capture,         '(',   4,  5
    include_examples 'scan token',  5, :literal,      :literal,         'c',   5,  6
    include_examples 'scan token',  6, :group,        :close,           ')',   6,  7
    include_examples 'scan token',  7, :group,        :close,           ')',   7,  8
    include_examples 'scan token',  8, :group,        :close,           ')',   8,  9
    include_examples 'scan token',  9, :conditional,  :open,            '(?',  9, 11
    include_examples 'scan token', 10, :conditional,  :condition_open,  '(',  11, 12
    include_examples 'scan token', 11, :conditional,  :condition,       '1',  12, 13
    include_examples 'scan token', 12, :conditional,  :condition_close, ')',  13, 14
    include_examples 'scan token', 13, :conditional,  :open,            '(?', 14, 16
    include_examples 'scan token', 14, :conditional,  :condition_open,  '(',  16, 17
    include_examples 'scan token', 15, :conditional,  :condition,       '2',  17, 18
    include_examples 'scan token', 16, :conditional,  :condition_close, ')',  18, 19
    include_examples 'scan token', 17, :literal,      :literal,         'd',  19, 20
    include_examples 'scan token', 18, :conditional,  :separator,       '|',  20, 21
    include_examples 'scan token', 19, :conditional,  :open,            '(?', 21, 23
    include_examples 'scan token', 20, :conditional,  :condition_open,  '(',  23, 24
    include_examples 'scan token', 21, :conditional,  :condition,       '3',  24, 25
    include_examples 'scan token', 22, :conditional,  :condition_close, ')',  25, 26
    include_examples 'scan token', 23, :literal,      :literal,         'e',  26, 27
    include_examples 'scan token', 24, :conditional,  :separator,       '|',  27, 28
    include_examples 'scan token', 25, :literal,      :literal,         'f',  28, 29
    include_examples 'scan token', 26, :conditional,  :close,           ')',  29, 30
    include_examples 'scan token', 27, :conditional,  :close,           ')',  30, 31
    include_examples 'scan token', 28, :conditional,  :separator,       '|',  31, 32
    include_examples 'scan token', 29, :conditional,  :open,            '(?', 32, 34
    include_examples 'scan token', 30, :conditional,  :condition_open,  '(',  34, 35
    include_examples 'scan token', 31, :conditional,  :condition,       '2',  35, 36
    include_examples 'scan token', 32, :conditional,  :condition_close, ')',  36, 37
    include_examples 'scan token', 33, :conditional,  :open,            '(?', 37, 39
    include_examples 'scan token', 34, :conditional,  :condition_open,  '(',  39, 40
    include_examples 'scan token', 35, :conditional,  :condition,       '1',  40, 41
    include_examples 'scan token', 36, :conditional,  :condition_close, ')',  41, 42
    include_examples 'scan token', 37, :literal,      :literal,         'g',  42, 43
    include_examples 'scan token', 38, :conditional,  :separator,       '|',  43, 44
    include_examples 'scan token', 39, :literal,      :literal,         'h',  44, 45
    include_examples 'scan token', 40, :conditional,  :close,           ')',  45, 46
    include_examples 'scan token', 41, :conditional,  :close,           ')',  46, 47
    include_examples 'scan token', 42, :conditional,  :close,           ')',  47, 48
  end

  describe('scan conditional nested groups') do
    let(:tokens) { RS.scan('((a)|(b)|((?(2)(c(d|e)+)?|(?(3)f|(?(4)(g|(h)(i)))))))') }

    include_examples 'scan token',  0, :group,        :capture,         '(',   0,  1
    include_examples 'scan token',  1, :group,        :capture,         '(',   1,  2
    include_examples 'scan token',  2, :literal,      :literal,         'a',   2,  3
    include_examples 'scan token',  3, :group,        :close,           ')',   3,  4
    include_examples 'scan token',  4, :meta,         :alternation,     '|',   4,  5
    include_examples 'scan token',  5, :group,        :capture,         '(',   5,  6
    include_examples 'scan token',  6, :literal,      :literal,         'b',   6,  7
    include_examples 'scan token',  7, :group,        :close,           ')',   7,  8
    include_examples 'scan token',  8, :meta,         :alternation,     '|',   8,  9
    include_examples 'scan token',  9, :group,        :capture,         '(',   9, 10
    include_examples 'scan token', 10, :conditional,  :open,            '(?', 10, 12
    include_examples 'scan token', 11, :conditional,  :condition_open,  '(',  12, 13
    include_examples 'scan token', 12, :conditional,  :condition,       '2',  13, 14
    include_examples 'scan token', 13, :conditional,  :condition_close, ')',  14, 15
    include_examples 'scan token', 14, :group,        :capture,         '(',  15, 16
    include_examples 'scan token', 15, :literal,      :literal,         'c',  16, 17
    include_examples 'scan token', 16, :group,        :capture,         '(',  17, 18
    include_examples 'scan token', 17, :literal,      :literal,         'd',  18, 19
    include_examples 'scan token', 18, :meta,         :alternation,     '|',  19, 20
    include_examples 'scan token', 19, :literal,      :literal,         'e',  20, 21
    include_examples 'scan token', 20, :group,        :close,           ')',  21, 22
    include_examples 'scan token', 21, :quantifier,   :one_or_more,     '+',  22, 23
    include_examples 'scan token', 22, :group,        :close,           ')',  23, 24
    include_examples 'scan token', 23, :quantifier,   :zero_or_one,     '?',  24, 25
    include_examples 'scan token', 24, :conditional,  :separator,       '|',  25, 26
    include_examples 'scan token', 25, :conditional,  :open,            '(?', 26, 28
    include_examples 'scan token', 26, :conditional,  :condition_open,  '(',  28, 29
    include_examples 'scan token', 27, :conditional,  :condition,       '3',  29, 30
    include_examples 'scan token', 28, :conditional,  :condition_close, ')',  30, 31
    include_examples 'scan token', 29, :literal,      :literal,         'f',  31, 32
    include_examples 'scan token', 30, :conditional,  :separator,       '|',  32, 33
    include_examples 'scan token', 31, :conditional,  :open,            '(?', 33, 35
    include_examples 'scan token', 32, :conditional,  :condition_open,  '(',  35, 36
    include_examples 'scan token', 33, :conditional,  :condition,       '4',  36, 37
    include_examples 'scan token', 34, :conditional,  :condition_close, ')',  37, 38
    include_examples 'scan token', 35, :group,        :capture,         '(',  38, 39
    include_examples 'scan token', 36, :literal,      :literal,         'g',  39, 40
    include_examples 'scan token', 37, :meta,         :alternation,     '|',  40, 41
    include_examples 'scan token', 38, :group,        :capture,         '(',  41, 42
    include_examples 'scan token', 39, :literal,      :literal,         'h',  42, 43
    include_examples 'scan token', 40, :group,        :close,           ')',  43, 44
    include_examples 'scan token', 41, :group,        :capture,         '(',  44, 45
    include_examples 'scan token', 42, :literal,      :literal,         'i',  45, 46
    include_examples 'scan token', 43, :group,        :close,           ')',  46, 47
    include_examples 'scan token', 44, :group,        :close,           ')',  47, 48
    include_examples 'scan token', 45, :conditional,  :close,           ')',  48, 49
    include_examples 'scan token', 46, :conditional,  :close,           ')',  49, 50
    include_examples 'scan token', 47, :conditional,  :close,           ')',  50, 51
    include_examples 'scan token', 48, :group,        :close,           ')',  51, 52
    include_examples 'scan token', 49, :group,        :close,           ')',  52, 53
  end

  describe('scan conditional nested alternation') do
    let(:tokens) { RS.scan('(a)(?(1)(b|c|d)|(e|f|g))(h)(?(2)(i|j|k)|(l|m|n))|o|p') }

    include_examples 'scan token', 9,  :meta,        :alternation, '|', 10, 11
    include_examples 'scan token', 11, :meta,        :alternation, '|', 12, 13
    include_examples 'scan token', 14, :conditional, :separator,   '|', 15, 16
    include_examples 'scan token', 17, :meta,        :alternation, '|', 18, 19
    include_examples 'scan token', 19, :meta,        :alternation, '|', 20, 21
    include_examples 'scan token', 32, :meta,        :alternation, '|', 34, 35
    include_examples 'scan token', 34, :meta,        :alternation, '|', 36, 37
    include_examples 'scan token', 37, :conditional, :separator,   '|', 39, 40
    include_examples 'scan token', 40, :meta,        :alternation, '|', 42, 43
    include_examples 'scan token', 42, :meta,        :alternation, '|', 44, 45
    include_examples 'scan token', 46, :meta,        :alternation, '|', 48, 49
    include_examples 'scan token', 48, :meta,        :alternation, '|', 50, 51
  end
end
