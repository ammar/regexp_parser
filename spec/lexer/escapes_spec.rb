require 'spec_helper'

RSpec.describe('Escape lexing') do
  tests = {
    '\u{62}' => {
      0     => [:escape,     :codepoint_list,   '\u{62}',        0, 6,   0, 0, 0],
    },

    '\u{62 63 64}' => {
      0     => [:escape,     :codepoint_list,   '\u{62 63 64}',  0, 12,  0, 0, 0],
    },

    '\u{62 63 64}+' => {
      0     => [:escape,     :codepoint_list,   '\u{62 63}',     0,  9,  0, 0, 0],
      1     => [:escape,     :codepoint_list,   '\u{64}',        9,  15, 0, 0, 0],
      2     => [:quantifier, :one_or_more,      '+',             15, 16, 0, 0, 0],
    },
  }

  tests.each_with_index do |(pattern, checks), count|
    specify("lex_escape_runs_#{count}") do
      tokens = RL.lex(pattern)

      checks.each do |index, (type, token, text, ts, te, level, set_level, conditional_level)|
        struct = tokens.at(index)

        expect(struct.type).to eq type
        expect(struct.token).to eq token
        expect(struct.text).to eq text
        expect(struct.ts).to eq ts
        expect(struct.te).to eq te
        expect(struct.level).to eq level
        expect(struct.set_level).to eq set_level
        expect(struct.conditional_level).to eq conditional_level
      end
    end
  end
end
