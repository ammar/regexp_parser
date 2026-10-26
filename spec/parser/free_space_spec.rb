# frozen_string_literal: true

require 'spec_helper'

RSpec.describe('FreeSpace parsing') do
  include_examples 'parse', /a b c/,
    [0] => [RE::Literal, text: 'a b c']

  include_examples 'parse', /a b c/x,
    [0] => [RE::Literal, text: 'a'],
    [1] => [RE::WhiteSpace, text: ' '],
    [2] => [RE::Literal, text: 'b'],
    [3] => [RE::WhiteSpace, text: ' '],
    [4] => [RE::Literal, text: 'c']

  include_examples 'parse', /a * b + c/x,
    [0] => [RE::Literal, to_s: 'a*', quantified?: true],
    [1] => [RE::WhiteSpace, text: ' '],
    [2] => [RE::WhiteSpace, text: ' '],
    [3] => [RE::Literal, to_s: 'b+', quantified?: true],
    [4] => [RE::WhiteSpace, text: ' '],
    [5] => [RE::WhiteSpace, text: ' '],
    [6] => [RE::Literal, to_s: 'c']

  include_examples 'parse', /
      a   ?     # One letter
      b {2,5}   # Another one
      [c-g]  +  # A set
      (h|i|j)   # A group
    /x,
    [0]  => [RE::WhiteSpace],
    [1]  => [RE::Literal, to_s: 'a?', quantified?: true],
    [2]  => [RE::WhiteSpace, text: '   '],
    [3]  => [RE::WhiteSpace, text: '     '],
    [4]  => [RE::Comment, to_s: "# One letter\n"],
    [5]  => [RE::WhiteSpace],
    [6]  => [RE::Literal, to_s: 'b{2,5}', quantified?: true],
    [7]  => [RE::WhiteSpace, text: ' '],
    [8]  => [RE::WhiteSpace, text: '   '],
    [9]  => [RE::Comment, to_s: "# Another one\n"],
    [10] => [RE::WhiteSpace],
    [11] => [RE::CharacterSet, to_s: '[c-g]+', quantified?: true],
    [12] => [RE::WhiteSpace],
    [13] => [RE::WhiteSpace],
    [14] => [RE::Comment, to_s: "# A set\n"],
    [15] => [RE::WhiteSpace],
    [16] => [RE::Group::Capture],
    [17] => [RE::WhiteSpace],
    [18] => [RE::Comment, to_s: "# A group\n",]

  include_examples 'parse', /
      a
      # comment 1
      ?
      (
       b # comment 2
       # comment 3
       +
      )
      # comment 4
      *
    /x,
    [0]    => [RE::WhiteSpace],
    [1]    => [RE::Literal, to_s: 'a?', quantified?: true],
    [2]    => [RE::WhiteSpace],
    [3]    => [RE::Comment],
    [4]    => [RE::WhiteSpace],
    [5]    => [RE::WhiteSpace],
    [6]    => [RE::Group::Capture, quantified?: true],
    [6, 0] => [RE::WhiteSpace],
    [6, 1] => [RE::Literal, to_s: 'b+', quantified?: true],
    [6, 2] => [RE::WhiteSpace],
    [6, 3] => [RE::Comment, to_s: "# comment 2\n"],
    [6, 4] => [RE::WhiteSpace],
    [6, 5] => [RE::Comment, to_s: "# comment 3\n"],
    [6, 6] => [RE::WhiteSpace],
    [6, 7] => [RE::WhiteSpace]
end
