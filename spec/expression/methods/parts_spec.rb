# frozen_string_literal: true

require 'spec_helper'

RSpec.describe('Expression::Base#parts') do
  include_examples 'parse', //,        []  => [:root,      parts: []]
  include_examples 'parse', /a/,       [0] => [:literal,   parts: ['a']]
  include_examples 'parse', /\K/,      [0] => [:mark,      parts: ['\K']]
  include_examples 'parse', /\p{any}/, [0] => [:any,       parts: ['\p{any}']]
  include_examples 'parse', /[a]/,     [0] => [:character, parts: ['[', s(RE::Literal, 'a'), ']']]
  include_examples 'parse', /[^a]/,    [0] => [:character, parts: ['[^', s(RE::Literal, 'a'), ']']]
  include_examples 'parse', /(a)/,     [0] => [:capture,   parts: ['(', s(RE::Literal, 'a'), ')']]
  include_examples 'parse', /(?>a)/,   [0] => [:atomic,    parts: ['(?>', s(RE::Literal, 'a'), ')']]
  include_examples 'parse', /(?=a)/,   [0] => [:lookahead, parts: ['(?=', s(RE::Literal, 'a'), ')']]
  include_examples 'parse', /(?#a)/,   [0] => [:comment,   parts: ['(?#a)']]

  include_examples 'parse', /(a(b(c)))/,
    [0] => [:capture, parts: [
      '(',
      s(RE::Literal, 'a'),
      s(RE::Group::Capture, '(',
        s(RE::Literal, 'b'),
        s(RE::Group::Capture, '(',
          s(RE::Literal, 'c'),
        )
      ),
      ')'
    ]]

  include_examples 'parse', /a|b|c/,
    [] => [:root, parts: [
      s(RE::Alternation, '|',
        s(RE::Alternative, nil, s(RE::Literal, 'a')),
        s(RE::Alternative, nil, s(RE::Literal, 'b')),
        s(RE::Alternative, nil, s(RE::Literal, 'c'))
      )
    ]],
    [0] => [:alternation, parts: [
      s(RE::Alternative, nil, s(RE::Literal, 'a')),
      '|',
      s(RE::Alternative, nil, s(RE::Literal, 'b')),
      '|',
      s(RE::Alternative, nil, s(RE::Literal, 'c'))
    ]]

  include_examples 'parse', /[a-z]/,
    [] => [:root, parts: [
      s(RE::CharacterSet, '[',
        s(RE::CharacterSet::Range, '-', s(RE::Literal, 'a'), s(RE::Literal, 'z')),
      )
    ]],
    [0] => [:character, parts: [
      '[',
      s(RE::CharacterSet::Range, '-', s(RE::Literal, 'a'), s(RE::Literal, 'z')),
      ']'
    ]],
    [0, 0] => [:range, parts: [
      s(RE::Literal, 'a'),
      '-',
      s(RE::Literal, 'z')
    ]]

  include_examples 'parse', /[a&&b&&c]/,
    [] => [:root, parts: [
      s(RE::CharacterSet, '[',
        s(RE::CharacterSet::Intersection, '&&',
          s(RE::CharacterSet::IntersectedSequence, nil, s(RE::Literal, 'a')),
          s(RE::CharacterSet::IntersectedSequence, nil, s(RE::Literal, 'b')),
          s(RE::CharacterSet::IntersectedSequence, nil, s(RE::Literal, 'c'))
        )
      )
    ]],
    [0, 0] => [:intersection, parts: [
      s(RE::CharacterSet::IntersectedSequence, nil, s(RE::Literal, 'a')),
      '&&',
      s(RE::CharacterSet::IntersectedSequence, nil, s(RE::Literal, 'b')),
      '&&',
      s(RE::CharacterSet::IntersectedSequence, nil, s(RE::Literal, 'c'))
    ]]

  include_examples 'parse', /(a)(?(1)T|F)/,
    [1] => [RE::Conditional::Expression, parts: [
      '(?',
      s(RE::Conditional::Condition, '(1)'),
      s(RE::Conditional::Branch, nil, s(RE::Literal, 'T')),
      '|',
      s(RE::Conditional::Branch, nil, s(RE::Literal, 'F')),
      ')'
    ]]
end
