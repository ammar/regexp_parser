# frozen_string_literal: true

require 'spec_helper'

RSpec.describe('FreeSpace parsing') do
  include_examples 'parse', /a b c/,
    [0] => [Literal, text: 'a b c']

  include_examples 'parse', /a b c/x,
    [0] => [Literal, text: 'a'],
    [1] => [WhiteSpace, text: ' '],
    [2] => [Literal, text: 'b'],
    [3] => [WhiteSpace, text: ' '],
    [4] => [Literal, text: 'c']

  include_examples 'parse', /a * b + c/x,
    [0] => [Literal, to_s: 'a*', quantified?: true],
    [1] => [WhiteSpace, text: ' '],
    [2] => [WhiteSpace, text: ' '],
    [3] => [Literal, to_s: 'b+', quantified?: true],
    [4] => [WhiteSpace, text: ' '],
    [5] => [WhiteSpace, text: ' '],
    [6] => [Literal, to_s: 'c']

  include_examples 'parse', /
      a   ?     # One letter
      b {2,5}   # Another one
      [c-g]  +  # A set
      (h|i|j)   # A group
    /x,
    [0]  => [WhiteSpace],
    [1]  => [Literal, to_s: 'a?', quantified?: true],
    [2]  => [WhiteSpace, text: '   '],
    [3]  => [WhiteSpace, text: '     '],
    [4]  => [Comment, to_s: "# One letter\n"],
    [5]  => [WhiteSpace],
    [6]  => [Literal, to_s: 'b{2,5}', quantified?: true],
    [7]  => [WhiteSpace, text: ' '],
    [8]  => [WhiteSpace, text: '   '],
    [9]  => [Comment, to_s: "# Another one\n"],
    [10] => [WhiteSpace],
    [11] => [CharacterSet, to_s: '[c-g]+', quantified?: true],
    [12] => [WhiteSpace],
    [13] => [WhiteSpace],
    [14] => [Comment, to_s: "# A set\n"],
    [15] => [WhiteSpace],
    [16] => [Group::Capture],
    [17] => [WhiteSpace],
    [18] => [Comment, to_s: "# A group\n",]

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
    [0]    => [WhiteSpace],
    [1]    => [Literal, to_s: 'a?', quantified?: true],
    [2]    => [WhiteSpace],
    [3]    => [Comment],
    [4]    => [WhiteSpace],
    [5]    => [WhiteSpace],
    [6]    => [Group::Capture, quantified?: true],
    [6, 0] => [WhiteSpace],
    [6, 1] => [Literal, to_s: 'b+', quantified?: true],
    [6, 2] => [WhiteSpace],
    [6, 3] => [Comment, to_s: "# comment 2\n"],
    [6, 4] => [WhiteSpace],
    [6, 5] => [Comment, to_s: "# comment 3\n"],
    [6, 6] => [WhiteSpace],
    [6, 7] => [WhiteSpace]
end
