# frozen_string_literal: true

require 'spec_helper'

RSpec.describe('PosixClass parsing') do
  include_examples 'parse', /[[:word:]]/,
    [0]    => [RE::CharacterSet, count: 1],
    [0, 0] => [:posixclass,    :word, RE::PosixClass, name: 'word', text: '[:word:]']
  include_examples 'parse', /[[:^word:]]/,
    [0]    => [RE::CharacterSet, count: 1],
    [0, 0] => [:nonposixclass, :word, RE::PosixClass, name: 'word', text: '[:^word:]']

  # cases treated as regular subsets by Ruby, not as (invalid) posix classes
  include_examples 'parse', '[[:ab]c:]',
    [0, 0]    => [RE::CharacterSet, count: 3],
    [0, 0, 0] => [RE::Literal, text: ':']

  include_examples 'parse', '[[:a[b]c:]]',
    [0, 0]    => [RE::CharacterSet, count: 5],
    [0, 0, 0] => [RE::Literal, text: ':']
end
