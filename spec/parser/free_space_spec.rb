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
    [1] => [WhiteSpace, text: '  '],
    [2] => [Literal, to_s: 'b+', quantified?: true],
    [3] => [WhiteSpace, text: '  '],
    [4] => [Literal, to_s: 'c']

  include_examples 'parse', /
      a   ?     # One letter
      b {2,5}   # Another one
      [c-g]  +  # A set
      (h|i|j)   # A group
    /x,
    [1]  => [Literal, to_s: 'a?', quantified?: true],
    [2]  => [WhiteSpace],
    [3]  => [Comment, to_s: "# One letter\n"],
    [7]  => [Comment, to_s: "# Another one\n"],
    [11] => [Comment, to_s: "# A set\n"],
    [15] => [Comment, to_s: "# A group\n"]

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
    [1]    => [Literal, to_s: 'a?', quantified?: true],
    [5]    => [Group::Capture, quantified?: true],
    [5, 1] => [Literal, to_s: 'b+', quantified?: true],
    [5, 3] => [Comment, to_s: "# comment 2\n"]
end
