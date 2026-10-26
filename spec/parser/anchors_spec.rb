# frozen_string_literal: true

require 'spec_helper'

RSpec.describe('Anchor parsing') do
  include_examples 'parse', /^a/,  0 => [:anchor, :bol,              RE::Anchor::BOL]
  include_examples 'parse', /a$/,  1 => [:anchor, :eol,              RE::Anchor::EOL]

  include_examples 'parse', /\Aa/, 0 => [:anchor, :bos,              RE::Anchor::BOS]
  include_examples 'parse', /a\z/, 1 => [:anchor, :eos,              RE::Anchor::EOS]
  include_examples 'parse', /a\Z/, 1 => [:anchor, :eos_ob_eol,       RE::Anchor::EOSobEOL]

  include_examples 'parse', /a\b/, 1 => [:anchor, :word_boundary,    RE::Anchor::WordBoundary]
  include_examples 'parse', /a\B/, 1 => [:anchor, :nonword_boundary, RE::Anchor::NonWordBoundary]

  include_examples 'parse', /a\G/, 1 => [:anchor, :match_start,      RE::Anchor::MatchStart]

  include_examples 'parse', /\\A/, 0 => [:escape, :backslash,        RE::EscapeSequence::Literal]
end
