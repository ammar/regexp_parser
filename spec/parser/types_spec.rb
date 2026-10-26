# frozen_string_literal: true

require 'spec_helper'

RSpec.describe('CharacterType parsing') do
  include_examples 'parse', /a\dc/, 1 => [:type, :digit,     RE::CharacterType::Digit]
  include_examples 'parse', /a\Dc/, 1 => [:type, :nondigit,  RE::CharacterType::NonDigit]

  include_examples 'parse', /a\sc/, 1 => [:type, :space,     RE::CharacterType::Space]
  include_examples 'parse', /a\Sc/, 1 => [:type, :nonspace,  RE::CharacterType::NonSpace]

  include_examples 'parse', /a\hc/, 1 => [:type, :hex,       RE::CharacterType::Hex]
  include_examples 'parse', /a\Hc/, 1 => [:type, :nonhex,    RE::CharacterType::NonHex]

  include_examples 'parse', /a\wc/, 1 => [:type, :word,      RE::CharacterType::Word]
  include_examples 'parse', /a\Wc/, 1 => [:type, :nonword,   RE::CharacterType::NonWord]

  include_examples 'parse', 'a\Rc', 1 => [:type, :linebreak, RE::CharacterType::Linebreak]
  include_examples 'parse', 'a\Xc', 1 => [:type, :xgrapheme, RE::CharacterType::ExtendedGrapheme]
end
