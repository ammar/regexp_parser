require 'spec_helper'

RSpec.describe('Literal lexing') do
  # ascii, single byte characters
  include_examples 'lex', 'a', 0,   :literal,     :literal,       'a',        0, 1, 0, 0, 0

  include_examples 'lex', 'ab+', 0,   :literal,     :literal,       'a',        0, 1, 0, 0, 0
  include_examples 'lex', 'ab+', 1,   :literal,     :literal,       'b',        1, 2, 0, 0, 0
  include_examples 'lex', 'ab+', 2,   :quantifier,  :one_or_more,   '+',        2, 3, 0, 0, 0


  # 2 byte wide characters, Arabic
  include_examples 'lex', 'ا', 0,   :literal,     :literal,       'ا',        0, 2, 0, 0, 0

  include_examples 'lex', 'aاbبcت', 0,   :literal,     :literal,       'aاbبcت',   0, 9, 0, 0, 0

  include_examples 'lex', 'aاbبت?', 0,   :literal,     :literal,       'aاbب',     0, 6, 0, 0, 0
  include_examples 'lex', 'aاbبت?', 1,   :literal,     :literal,       'ت',        6, 8, 0, 0, 0
  include_examples 'lex', 'aاbبت?', 2,   :quantifier,  :zero_or_one,   '?',        8, 9, 0, 0, 0

  include_examples 'lex', 'aا?bبcت+', 0,   :literal,     :literal,       'a',        0, 1, 0, 0, 0
  include_examples 'lex', 'aا?bبcت+', 1,   :literal,     :literal,       'ا',        1, 3, 0, 0, 0
  include_examples 'lex', 'aا?bبcت+', 2,   :quantifier,  :zero_or_one,   '?',        3, 4, 0, 0, 0
  include_examples 'lex', 'aا?bبcت+', 3,   :literal,     :literal,       'bبc',      4, 8, 0, 0, 0
  include_examples 'lex', 'aا?bبcت+', 4,   :literal,     :literal,       'ت',        8, 10, 0, 0, 0
  include_examples 'lex', 'aا?bبcت+', 5,   :quantifier,  :one_or_more,   '+',        10, 11, 0, 0, 0

  include_examples 'lex', 'a(اbب+)cت?', 0,   :literal,     :literal,       'a',        0, 1, 0, 0, 0
  include_examples 'lex', 'a(اbب+)cت?', 1,   :group,       :capture,       '(',        1, 2, 0, 0, 0
  include_examples 'lex', 'a(اbب+)cت?', 2,   :literal,     :literal,       'اb',       2, 5, 1, 0, 0
  include_examples 'lex', 'a(اbب+)cت?', 3,   :literal,     :literal,       'ب',        5, 7, 1, 0, 0
  include_examples 'lex', 'a(اbب+)cت?', 4,   :quantifier,  :one_or_more,   '+',        7, 8, 1, 0, 0
  include_examples 'lex', 'a(اbب+)cت?', 5,   :group,       :close,         ')',        8, 9, 0, 0, 0
  include_examples 'lex', 'a(اbب+)cت?', 6,   :literal,     :literal,       'c',        9, 10, 0, 0, 0
  include_examples 'lex', 'a(اbب+)cت?', 7,   :literal,     :literal,       'ت',        10, 12, 0, 0, 0
  include_examples 'lex', 'a(اbب+)cت?', 8,   :quantifier,  :zero_or_one,   '?',        12, 13, 0, 0, 0

  # 3 byte wide characters, Japanese
  include_examples 'lex', 'ab?れます+cd', 0,   :literal,     :literal,       'a',        0, 1, 0, 0, 0
  include_examples 'lex', 'ab?れます+cd', 1,   :literal,     :literal,       'b',        1, 2, 0, 0, 0
  include_examples 'lex', 'ab?れます+cd', 2,   :quantifier,  :zero_or_one,   '?',        2, 3, 0, 0, 0
  include_examples 'lex', 'ab?れます+cd', 3,   :literal,     :literal,       'れま',     3, 9, 0, 0, 0
  include_examples 'lex', 'ab?れます+cd', 4,   :literal,     :literal,       'す',       9, 12, 0, 0, 0
  include_examples 'lex', 'ab?れます+cd', 5,   :quantifier,  :one_or_more,   '+',        12, 13, 0, 0, 0
  include_examples 'lex', 'ab?れます+cd', 6,   :literal,     :literal,       'cd',       13, 15, 0, 0, 0

  # 4 byte wide characters, Osmanya
  include_examples 'lex', '𐒀𐒁?𐒂ab+𐒃', 0,   :literal,     :literal,       '𐒀',        0, 4, 0, 0, 0
  include_examples 'lex', '𐒀𐒁?𐒂ab+𐒃', 1,   :literal,     :literal,       '𐒁',        4, 8, 0, 0, 0
  include_examples 'lex', '𐒀𐒁?𐒂ab+𐒃', 2,   :quantifier,  :zero_or_one,   '?',        8, 9, 0, 0, 0
  include_examples 'lex', '𐒀𐒁?𐒂ab+𐒃', 3,   :literal,     :literal,       '𐒂a',       9, 14, 0, 0, 0
  include_examples 'lex', '𐒀𐒁?𐒂ab+𐒃', 4,   :literal,     :literal,       'b',        14, 15, 0, 0, 0
  include_examples 'lex', '𐒀𐒁?𐒂ab+𐒃', 5,   :quantifier,  :one_or_more,   '+',        15, 16, 0, 0, 0
  include_examples 'lex', '𐒀𐒁?𐒂ab+𐒃', 6,   :literal,     :literal,       '𐒃',        16, 20, 0, 0, 0

  include_examples 'lex', 'mu𝄞?si*𝄫c+', 0,   :literal,     :literal,       'mu',       0, 2, 0, 0, 0
  include_examples 'lex', 'mu𝄞?si*𝄫c+', 1,   :literal,     :literal,       '𝄞',        2, 6, 0, 0, 0
  include_examples 'lex', 'mu𝄞?si*𝄫c+', 2,   :quantifier,  :zero_or_one,   '?',        6, 7, 0, 0, 0
  include_examples 'lex', 'mu𝄞?si*𝄫c+', 3,   :literal,     :literal,       's',        7, 8, 0, 0, 0
  include_examples 'lex', 'mu𝄞?si*𝄫c+', 4,   :literal,     :literal,       'i',        8, 9, 0, 0, 0
  include_examples 'lex', 'mu𝄞?si*𝄫c+', 5,   :quantifier,  :zero_or_more,  '*',        9, 10, 0, 0, 0
  include_examples 'lex', 'mu𝄞?si*𝄫c+', 6,   :literal,     :literal,       '𝄫',        10, 14, 0, 0, 0
  include_examples 'lex', 'mu𝄞?si*𝄫c+', 7,   :literal,     :literal,       'c',        14, 15, 0, 0, 0
  include_examples 'lex', 'mu𝄞?si*𝄫c+', 8,   :quantifier,  :one_or_more,   '+',        15, 16, 0, 0, 0

  specify('lex single 2 byte char') do
    tokens = RL.lex("\u0627+")
    expect(tokens.count).to eq 2
  end

  specify('lex single 3 byte char') do
    tokens = RL.lex("\u308C+")
    expect(tokens.count).to eq 2
  end

  specify('lex single 4 byte char') do
    tokens = RL.lex("\u{1D11E}+")
    expect(tokens.count).to eq 2
  end
end
