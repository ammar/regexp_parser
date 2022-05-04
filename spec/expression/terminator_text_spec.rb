require 'spec_helper'

RSpec.describe('Expression::Base#terminator_text') do
  include_examples 'parse', //,        []  => [:root,      terminator_text: nil]
  include_examples 'parse', /a/,       [0] => [:literal,   terminator_text: nil]
  include_examples 'parse', /\K/,      [0] => [:mark,      terminator_text: nil]
  include_examples 'parse', /\p{any}/, [0] => [:any,       terminator_text: nil]
  include_examples 'parse', /[a]/,     [0] => [:character, terminator_text: ']']
  include_examples 'parse', /(a)/,     [0] => [:capture,   terminator_text: ')']
  include_examples 'parse', /(?>a)/,   [0] => [:atomic,    terminator_text: ')']
  include_examples 'parse', /(?=a)/,   [0] => [:lookahead, terminator_text: ')']
  # special case: for comment groups, the ')' is included in the scanned #text
  include_examples 'parse', /(?#a)/,   [0] => [:comment,   terminator_text: nil]
end
