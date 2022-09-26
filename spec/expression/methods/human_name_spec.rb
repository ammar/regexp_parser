require 'spec_helper'

RSpec.describe('Regexp::Expression::Shared#human_name') do
  include_examples 'parse', //,              []      => [human_name: 'root']
  include_examples 'parse', /a/,             [0]     => [human_name: 'literal']
  include_examples 'parse', /./,             [0]     => [human_name: 'match-all']
  include_examples 'parse', /[abc]/,         [0]     => [human_name: 'character set']
  include_examples 'parse', /[a-c]/,         [0, 0]  => [human_name: 'character range']
  include_examples 'parse', /\d/,            [0]     => [human_name: 'digit type']
  include_examples 'parse', /\n/,            [0]     => [human_name: 'newline escape']
  include_examples 'parse', /\u{61 62 63}/,  [0]     => [human_name: 'codepoint list escape']
  include_examples 'parse', /\p{ascii}/,     [0]     => [human_name: 'ascii property']
  include_examples 'parse', /[[:ascii:]]/,   [0, 0]  => [human_name: 'ascii posixclass']
  include_examples 'parse', /a{5}/,          [0, :q] => [human_name: 'interval quantifier']
  include_examples 'parse', /^/,             [0]     => [human_name: 'beginning of line']
  include_examples 'parse', /(?=abc)/,       [0]     => [human_name: 'lookahead']
  include_examples 'parse', /(a)(b)/,        [0]     => [human_name: 'capture group 1']
  include_examples 'parse', /(a)(b)/,        [1]     => [human_name: 'capture group 2']
  include_examples 'parse', /(?<x>abc)/,     [0]     => [human_name: 'named capture group']
  include_examples 'parse', /   /x,          [0]     => [human_name: 'free space']
  include_examples 'parse', /#comment
                            /x,              [0]     => [human_name: 'comment']
  include_examples 'parse', /(?#comment)/x,  [0]     => [human_name: 'comment group']
  include_examples 'parse', /(abc)\1/,       [1]     => [human_name: 'backreference']
  include_examples 'parse', /(?<x>)\k<x>/,   [1]     => [human_name: 'backreference by name']
  include_examples 'parse', /(abc)\g<-1>/,   [1]     => [human_name: 'relative subexpression call']
  include_examples 'parse', /a|bc/,          [0]     => [human_name: 'alternation']
  include_examples 'parse', /a|bc/,          [0, 0]  => [human_name: 'alternative']
end
