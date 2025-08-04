# frozen_string_literal: true

require 'spec_helper'

RSpec.describe('Alternation parsing') do
  include_examples 'parse', /a|b/,
    [0]       => [Alternation, text: '|', count: 2],
    [0, 0]    => [Alternative, text: '',  count: 1],
    [0, 0, 0] => [:literal,    text: 'a'          ],
    [0, 1]    => [Alternative, text: '',  count: 1],
    [0, 1, 0] => [:literal,    text: 'b'          ]

  include_examples 'parse', /a|(b)c/,
    [0]       => [Alternation, text: '|', count: 2],
    [0, 0]    => [Alternative, text: '',  count: 1],
    [0, 0, 0] => [:literal,    text: 'a'          ],
    [0, 1]    => [Alternative, text: '',  count: 2],
    [0, 1, 0] => [:capture,    to_s: '(b)'        ],
    [0, 1, 1] => [:literal,    text: 'c'          ]

  include_examples 'parse', /(ab??|cd*|ef+)*|(gh|ij|kl)?/,
    [0]                => [Alternation, text: '|', count: 2, quantified?: false],
    [0, 0]             => [Alternative, text: '',  count: 1, quantified?: false],
    [0, 0, 0]          => [:capture,               count: 1, quantified?: true ],
    [0, 0, 0, 0]       => [Alternation, text: '|', count: 3                    ],
    [0, 0, 0, 0, 0]    => [Alternative, text: '',  count: 2                    ],
    [0, 0, 0, 0, 0, 0] => [:literal,    to_s: 'a'                              ],
    [0, 0, 0, 0, 0, 1] => [:literal,    to_s: 'b??'                            ],
    [0, 1]             => [Alternative, text: '',  count: 1, quantified?: false],
    [0, 1, 0]          => [:capture,               count: 1, quantified?: true ]

  # test correct ts values for empty sequences
  include_examples 'parse', /|||/,
    [0]       => [Alternation, text: '|', count: 4, starts_at: 0],
    [0, 0]    => [Alternative, to_s: '',  count: 0, starts_at: 0],
    [0, 1]    => [Alternative, to_s: '',  count: 0, starts_at: 1],
    [0, 2]    => [Alternative, to_s: '',  count: 0, starts_at: 2],
    [0, 3]    => [Alternative, to_s: '',  count: 0, starts_at: 3]

  # test correct ts values for non-empty sequences
  include_examples 'parse', /ab|cd|ef|gh/,
    [0]       => [Alternation, text: '|',   count: 4, starts_at: 0],
    [0, 0]    => [Alternative, to_s: 'ab',  count: 1, starts_at: 0],
    [0, 1]    => [Alternative, to_s: 'cd',  count: 1, starts_at: 3],
    [0, 2]    => [Alternative, to_s: 'ef',  count: 1, starts_at: 6],
    [0, 3]    => [Alternative, to_s: 'gh',  count: 1, starts_at: 9]
end
