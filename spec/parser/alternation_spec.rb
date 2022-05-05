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
end
