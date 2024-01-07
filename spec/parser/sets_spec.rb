require 'spec_helper'

RSpec.describe('CharacterSet parsing') do
  include_examples 'parse', /[ab]+/,
    [0]    => [:set, :character, CharacterSet, text: '[', count: 2, quantified?: true],
    [0, 0] => [:literal, :literal, Literal, text: 'a', set_level: 1],
    [0, 1] => [:literal, :literal, Literal, text: 'b', set_level: 1]

  include_examples 'parse', /[a\dc]/,
    [0]    => [:set, :character, CharacterSet, text: '[', count: 3],
    [0, 1] => [:type, :digit, CharacterType::Digit]

  include_examples 'parse', /[a\bc]/,
    [0]    => [:set, :character, CharacterSet, text: '[', count: 3],
    [0, 1] => [:escape, :backspace, EscapeSequence::Backspace, text: '\b']

  include_examples 'parse', '[a\xFz]',
    [0]    => [:set, :character, CharacterSet, text: '[', count: 3],
    [0, 1] => [:escape, :hex, EscapeSequence::Hex, text: '\xF']

  include_examples 'parse', '[a\x20c]',
    [0]    => [:set, :character, CharacterSet, text: '[', count: 3],
    [0, 1] => [:escape, :hex, EscapeSequence::Hex, text: '\x20']

  include_examples 'parse', '[a\77c]',
    [0]    => [:set, :character, CharacterSet, text: '[', count: 3],
    [0, 1] => [:escape, :octal, EscapeSequence::Octal, text: '\77']

  include_examples 'parse', '[a\u0640c]',
    [0]    => [:set, :character, CharacterSet, text: '[', count: 3],
    [0, 1] => [:escape, :codepoint, EscapeSequence::Codepoint, text: '\u0640']

  include_examples 'parse', '[a\u{41 1F60D}c]',
    [0]    => [:set, :character, CharacterSet, text: '[', count: 3],
    [0, 1] => [:escape, :codepoint_list, EscapeSequence::CodepointList, text: '\u{41 1F60D}']

  include_examples 'parse', '[[:digit:][:^lower:]]+',
    [0]    => [:set, :character, CharacterSet, text: '[', count: 2],
    [0, 0] => [:posixclass, :digit, PosixClass, text: '[:digit:]'],
    [0, 1] => [:nonposixclass, :lower, PosixClass, text: '[:^lower:]']

  include_examples 'parse', '[a[b[c]d]e]',
    [0]          => [:set,     :character, CharacterSet, text: '[', count: 3, set_level: 0],
    [0, 0]       => [:literal, :literal,   Literal,      text: 'a',           set_level: 1],
    [0, 1]       => [:set,     :character, CharacterSet, text: '[', count: 3, set_level: 1],
    [0, 2]       => [:literal, :literal,   Literal,      text: 'e',           set_level: 1],
    [0, 1, 1]    => [:set,     :character, CharacterSet, text: '[', count: 1, set_level: 2],
    [0, 1, 1, 0] => [:literal, :literal,   Literal,      text: 'c',           set_level: 3]

  include_examples 'parse', '[a[^b[c]]]',
    [0]          => [:set,     :character, CharacterSet, text: '[', count: 2, set_level: 0],
    [0, 0]       => [:literal, :literal,   Literal,      text: 'a',           set_level: 1],
    [0, 1]       => [:set,     :character, CharacterSet, text: '[', count: 2, set_level: 1],
    [0, 1, 0]    => [:literal, :literal,   Literal,      text: 'b',           set_level: 2],
    [0, 1, 1]    => [:set,     :character, CharacterSet, text: '[', count: 1, set_level: 2],
    [0, 1, 1, 0] => [:literal, :literal,   Literal,      text: 'c',           set_level: 3]

  include_examples 'parse', '[aaa]',
    [0]     => [:set,     :character, CharacterSet, text: '[', count: 3],
    [0, 0]  => [:literal, :literal,   Literal,      text: 'a'],
    [0, 1]  => [:literal, :literal,   Literal,      text: 'a'],
    [0, 2]  => [:literal, :literal,   Literal,      text: 'a']

  include_examples 'parse', '[   ]',
    [0]     => [:set,     :character, CharacterSet, text: '[', count: 3],
    [0, 0]  => [:literal, :literal,   Literal,      text: ' '],
    [0, 1]  => [:literal, :literal,   Literal,      text: ' '],
    [0, 2]  => [:literal, :literal,   Literal,      text: ' ']

  include_examples 'parse', '(?x)[   ]', # shouldn't merge whitespace even in x-mode
    [1]     => [:set,     :character, CharacterSet, text: '[', count: 3],
    [1, 0]  => [:literal, :literal,   Literal,      text: ' '],
    [1, 1]  => [:literal, :literal,   Literal,      text: ' '],
    [1, 2]  => [:literal, :literal,   Literal,      text: ' ']

  include_examples 'parse', '[[.span-ll.]]', # collating sequences are disabled in Onigmo
    [0, 0]    => [:set,     :character, CharacterSet, text: '[', count: 7],
    [0, 0, 0] => [:literal, :literal,   Literal,      text: '.']

  include_examples 'parse', '[[=e=]]', # character equivalents are disabled in Onigmo
    [0, 0]    => [:set,     :character, CharacterSet, text: '[', count: 3],
    [0, 0, 0] => [:literal, :literal,   Literal,      text: '=']
end
