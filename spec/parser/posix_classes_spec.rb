require 'spec_helper'

RSpec.describe('PosixClass parsing') do
  include_examples 'parse', /[[:word:]]/,
    [0]    => [CharacterSet, count: 1],
    [0, 0] => [:posixclass,    :word, PosixClass, name: 'word', text: '[:word:]', negative?: false]
  include_examples 'parse', /[[:^word:]]/,
    [0]    => [CharacterSet, count: 1],
    [0, 0] => [:nonposixclass, :word, PosixClass, name: 'word', text: '[:^word:]', negative?: true]

  # cases treated as regular subsets by Ruby, not as (invalid) posix classes
  include_examples 'parse', /[[:ab]c:]/,
    [0, 0]    => [CharacterSet, count: 3],
    [0, 0, 0] => [Literal, text: ':']

  include_examples 'parse', /[[:a[b]c:]]/,
    [0, 0]    => [CharacterSet, count: 5],
    [0, 0, 0] => [Literal, text: ':']
end
