require 'spec_helper'

RSpec.describe(Regexp::Expression::Base) do
  # test #level
  include_examples 'parse', /^a(b(c(d)))e$/,
    [0]          => [to_s: '^',         level: 0],
    [1]          => [to_s: 'a',         level: 0],
    [2]          => [to_s: '(b(c(d)))', level: 0],
    [2, 0]       => [to_s: 'b',         level: 1],
    [2, 1]       => [to_s: '(c(d))',    level: 1],
    [2, 1, 0]    => [to_s: 'c',         level: 2],
    [2, 1, 1]    => [to_s: '(d)',       level: 2],
    [2, 1, 1, 0] => [to_s: 'd',         level: 3],
    [3]          => [to_s: 'e',         level: 0],
    [4]          => [to_s: '$',         level: 0]

  # test #coded_offset
  include_examples 'parse', /^a*(b+(c?))$/,
    []        => [Root,             coded_offset: '@0+12'],
    [0]       => [to_s: '^',        coded_offset: '@0+1'],
    [1]       => [to_s: 'a*',       coded_offset: '@1+2'],
    [2]       => [to_s: '(b+(c?))', coded_offset: '@3+8'],
    [2, 0]    => [to_s: 'b+',       coded_offset: '@4+2'],
    [2, 1]    => [to_s: '(c?)',     coded_offset: '@6+4'],
    [2, 1, 0] => [to_s: 'c?',       coded_offset: '@7+2'],
    [3]       => [to_s: '$',        coded_offset: '@11+1']

  # test #quantity
  include_examples 'parse', /aa/, [0] => [quantity: [nil, nil]]
  include_examples 'parse', /a?/, [0] => [quantity: [0, 1]]
  include_examples 'parse', /a*/, [0] => [quantity: [0, -1]]
  include_examples 'parse', /a+/, [0] => [quantity: [1, -1]]

  # test #repetitions
  include_examples 'parse', /aa/, [0] => [repetitions: 1..1]
  include_examples 'parse', /a?/, [0] => [repetitions: 0..1]
  include_examples 'parse', /a*/, [0] => [repetitions: 0..(Float::INFINITY)]
  include_examples 'parse', /a+/, [0] => [repetitions: 1..(Float::INFINITY)]

  # test #base_length, #full_length, :ends_at
  include_examples 'parse', /(aa)/,
    []     => [Root,           base_length: 4, full_length: 4, ends_at: 4],
    [0]    => [Group::Capture, base_length: 4, full_length: 4, ends_at: 4],
    [0, 0] => [Literal,        base_length: 2, full_length: 2, ends_at: 3]
  include_examples 'parse', /(aa){42}/,
    []     => [Root,           base_length: 8, full_length: 8, ends_at: 8],
    [0]    => [Group::Capture, base_length: 4, full_length: 8, ends_at: 4],
    [0, 0] => [Literal,        base_length: 2, full_length: 2, ends_at: 3]
  include_examples 'parse', /(aa) {42}/x,
    []     => [Root,           base_length: 9, full_length: 9, ends_at: 9],
    [0]    => [Group::Capture, base_length: 4, full_length: 9, ends_at: 4],
    [0, 0] => [Literal,        base_length: 2, full_length: 2, ends_at: 3]

  # test #to_re
  include_examples 'parse', '^a*(b([cde]+))+f?$',
    [] => [Root, to_re: /^a*(b([cde]+))+f?$/]

  specify '#parent' do
    root = Regexp::Parser.parse(/(a(b)){42}/)

    expect(root.parent).to be_nil
    expect(root[0].parent).to eq root
    expect(root[0].quantifier.parent).to be_nil
    expect(root[0][0].parent).to eq root[0]
    expect(root[0][1].parent).to eq root[0]
    expect(root[0][1][0].parent).to eq root[0][1]
  end

  specify '#to_re warns when used on set members' do
    expect do
      result = Regexp::Parser.parse(/[\b]/)[0][0].to_re
      expect(result).to eq(/\b/)
    end.to output(/set member/).to_stderr
  end

  specify 'updating #quantifier updates #repetitions' do
    exp = Regexp::Parser.parse(/a{3}/)[0]
    expect(exp.repetitions).to eq 3..3
    exp.quantifier = Regexp::Parser.parse(/b{5}/)[0].quantifier
    expect(exp.repetitions).to eq 5..5
  end
end
