# frozen_string_literal: true

require 'spec_helper'

RSpec.describe('Expression::Base#negative?') do
  include_examples 'parse', //,            []  => [:root,             negative?: false]
  include_examples 'parse', /a/,           [0] => [:literal,          negative?: false]

  include_examples 'parse', /\b/,          [0] => [:word_boundary,    negative?: false]
  include_examples 'parse', /\B/,          [0] => [:nonword_boundary, negative?: true]

  include_examples 'parse', /(?=)/,        [0] => [:lookahead,        negative?: false]
  include_examples 'parse', /(?!)/,        [0] => [:nlookahead,       negative?: true]

  include_examples 'parse', /(?<=)/,       [0] => [:lookbehind,       negative?: false]
  include_examples 'parse', /(?<!)/,       [0] => [:nlookbehind,      negative?: true]

  include_examples 'parse', /[a]/,         [0] => [:character,        negative?: false]
  include_examples 'parse', /[^a]/,        [0] => [:character,        negative?: true]

  include_examples 'parse', /\d/,          [0] => [:digit,            negative?: false]
  include_examples 'parse', /\D/,          [0] => [:nondigit,         negative?: true]

  include_examples 'parse', /[[:word:]]/,  [0, 0] => [:word,          negative?: false]
  include_examples 'parse', /[[:^word:]]/, [0, 0] => [:word,          negative?: true]

  include_examples 'parse', /\p{word}/,    [0] => [:word,             negative?: false]
  include_examples 'parse', /\p{^word}/,   [0] => [:word,             negative?: true]

  include_examples 'parse', //,            []  => [:root,             negated?: false]
  include_examples 'parse', /[^a]/,        [0] => [:character,        negated?: true]
end
