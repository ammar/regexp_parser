require 'spec_helper'

RSpec.describe('Expression::Base#parts') do
  include_examples 'parse', //,        []  => [:root,      parts: []]
  include_examples 'parse', /a/,       [0] => [:literal,   parts: ['a']]
  include_examples 'parse', /\K/,      [0] => [:mark,      parts: ['\K']]
  include_examples 'parse', /\p{any}/, [0] => [:any,       parts: ['\p{any}']]
  include_examples 'parse', /[a]/,     [0] => [:character, parts: ['[', s(Literal, 'a'), ']']]
  include_examples 'parse', /[^a]/,    [0] => [:character, parts: ['[^', s(Literal, 'a'), ']']]
  include_examples 'parse', /(a)/,     [0] => [:capture,   parts: ['(', s(Literal, 'a'), ')']]
  include_examples 'parse', /(?>a)/,   [0] => [:atomic,    parts: ['(?>', s(Literal, 'a'), ')']]
  include_examples 'parse', /(?=a)/,   [0] => [:lookahead, parts: ['(?=', s(Literal, 'a'), ')']]
  include_examples 'parse', /(?#a)/,   [0] => [:comment,   parts: ['(?#a)']]

  include_examples 'parse', /(a(b(c)))/,
    [0] => [:capture, parts: [
      '(',
      s(Literal, 'a'),
      s(Group::Capture, '(',
        s(Literal, 'b'),
        s(Group::Capture, '(',
          s(Literal, 'c'),
        )
      ),
      ')'
    ]]

  include_examples 'parse', /a|b|c/,
    [] => [:root, parts: [
      s(Alternation, '|',
        s(Alternative, nil, s(Literal, 'a')),
        s(Alternative, nil, s(Literal, 'b')),
        s(Alternative, nil, s(Literal, 'c'))
      )
    ]],
    [0] => [:alternation, parts: [
      s(Alternative, nil, s(Literal, 'a')),
      '|',
      s(Alternative, nil, s(Literal, 'b')),
      '|',
      s(Alternative, nil, s(Literal, 'c'))
    ]]

  include_examples 'parse', /[a-z]/,
    [] => [:root, parts: [
      s(CharacterSet, '[',
        s(CharacterSet::Range, '-', s(Literal, 'a'), s(Literal, 'z')),
      )
    ]],
    [0] => [:character, parts: [
      '[',
      s(CharacterSet::Range, '-', s(Literal, 'a'), s(Literal, 'z')),
      ']'
    ]],
    [0, 0] => [:range, parts: [
      s(Literal, 'a'),
      '-',
      s(Literal, 'z')
    ]]

  include_examples 'parse', /[a&&b&&c]/,
    [] => [:root, parts: [
      s(CharacterSet, '[',
        s(CharacterSet::Intersection, '&&', s(Literal, 'a'), s(Literal, 'b'), s(Literal, 'c')),
      )
    ]],
    [0, 0] => [:intersection, parts: [
      s(CharacterSet::IntersectedSequence, nil, s(Literal, 'a')),
      '&&',
      s(CharacterSet::IntersectedSequence, nil, s(Literal, 'b')),
      '&&',
      s(CharacterSet::IntersectedSequence, nil, s(Literal, 'c'))
    ]]

  include_examples 'parse', /(a)(?(1)T|F)/,
    [1] => [Conditional::Expression, parts: [
      '(?',
      s(Conditional::Condition, '(1)'),
      s(Conditional::Branch, nil, s(Literal, 'T')),
      '|',
      s(Conditional::Branch, nil, s(Literal, 'F')),
      ')'
    ]]
end
