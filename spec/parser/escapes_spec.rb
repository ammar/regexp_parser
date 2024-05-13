require 'spec_helper'

RSpec.describe('EscapeSequence parsing') do
  es = EscapeSequence

  include_examples 'parse', /a\ac/,          1 => [:escape, :bell,           es::Bell]
  include_examples 'parse', /a\ec/,          1 => [:escape, :escape,         es::AsciiEscape]
  include_examples 'parse', /a\fc/,          1 => [:escape, :form_feed,      es::FormFeed]
  include_examples 'parse', /a\nc/,          1 => [:escape, :newline,        es::Newline]
  include_examples 'parse', /a\rc/,          1 => [:escape, :carriage,       es::Return]
  include_examples 'parse', /a\tc/,          1 => [:escape, :tab,            es::Tab]
  include_examples 'parse', /a\vc/,          1 => [:escape, :vertical_tab,   es::VerticalTab]

  # meta character escapes
  include_examples 'parse', /a\.c/,          1 => [:escape, :dot,            es::Literal]
  include_examples 'parse', /a\?c/,          1 => [:escape, :zero_or_one,    es::Literal]
  include_examples 'parse', /a\*c/,          1 => [:escape, :zero_or_more,   es::Literal]
  include_examples 'parse', /a\+c/,          1 => [:escape, :one_or_more,    es::Literal]
  include_examples 'parse', /a\|c/,          1 => [:escape, :alternation,    es::Literal]
  include_examples 'parse', /a\(c/,          1 => [:escape, :group_open,     es::Literal]
  include_examples 'parse', /a\)c/,          1 => [:escape, :group_close,    es::Literal]
  include_examples 'parse', /a\{c/,          1 => [:escape, :interval_open,  es::Literal]
  include_examples 'parse', /a\}c/,          1 => [:escape, :interval_close, es::Literal]

  # unicode escapes
  include_examples 'parse', /a\u0640/,       1 => [:escape, :codepoint,      es::Codepoint]
  include_examples 'parse', /a\u{41 1F60D}/, 1 => [:escape, :codepoint_list, es::CodepointList]
  include_examples 'parse', /a\u{10FFFF}/,   1 => [:escape, :codepoint_list, es::CodepointList]

  # hex escapes
  include_examples 'parse', /a\xFF/n,        1 => [:escape, :hex,            es::Hex]

  # octal escapes
  include_examples 'parse', /a\177/n,        1 => [:escape, :octal,          es::Octal]

  # test #char and #codepoint
  include_examples 'parse', /\n/,            0 => [char:  "\n",    codepoint:  10      ]
  include_examples 'parse', /\?/,            0 => [char:  '?',     codepoint:  63      ]
  include_examples 'parse', /\101/,          0 => [char:  'A',     codepoint:  65      ]
  include_examples 'parse', /\x42/,          0 => [char:  'B',     codepoint:  66      ]
  include_examples 'parse', /\u0043/,        0 => [char:  'C',     codepoint:  67      ]
  include_examples 'parse', /\u{44 45}/,     0 => [chars: %w[D E], codepoints: [68, 69]]

  specify('codepoint_list #char and #codepoint raise errors') do
    exp = RP.parse(/\u{44 45}/)[0]
    expect { exp.char }.to raise_error(/#chars/)
    expect { exp.codepoint }.to raise_error(/#codepoints/)
  end

  # Meta/control escapes
  #
  # After the following fix in Ruby 3.1, a Regexp#source containing meta/control
  # escapes can only be set with the Regexp::new constructor.
  # In Regexp literals, these escapes are now pre-processed to hex escapes.
  #
  # https://github.com/ruby/ruby/commit/11ae581a4a7f5d5f5ec6378872eab8f25381b1b9
  n = ->(regexp_body){ Regexp.new(regexp_body.force_encoding('ascii-8bit')) }

  include_examples 'parse', n.('\\\\\c2b'),  1 => [es::Control,     text: '\c2',     char: "\x12",   codepoint: 18 ]
  include_examples 'parse', n.('\d\C-C\w'),  1 => [es::Control,     text: '\C-C',    char: "\x03",   codepoint: 3  ]
  include_examples 'parse', n.('\Z\M-Z'),    1 => [es::Meta,        text: '\M-Z',    char: "\u00DA", codepoint: 218]
  include_examples 'parse', n.('\A\M-\C-X'), 1 => [es::MetaControl, text: '\M-\C-X', char: "\u0098", codepoint: 152]
  include_examples 'parse', n.('\A\M-\cX'),  1 => [es::MetaControl, text: '\M-\cX',  char: "\u0098", codepoint: 152]
  include_examples 'parse', n.('\A\C-\M-X'), 1 => [es::MetaControl, text: '\C-\M-X', char: "\u0098", codepoint: 152]
  include_examples 'parse', n.('\A\c\M-X'),  1 => [es::MetaControl, text: '\c\M-X',  char: "\u0098", codepoint: 152]
end
