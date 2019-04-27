require 'spec_helper'

RSpec.describe('Escape parsing') do
  tests = {
    /a\ac/          => [1, :escape, :bell,              EscapeSequence::Bell],
    /a\ec/          => [1, :escape, :escape,            EscapeSequence::AsciiEscape],
    /a\fc/          => [1, :escape, :form_feed,         EscapeSequence::FormFeed],
    /a\nc/          => [1, :escape, :newline,           EscapeSequence::Newline],
    /a\rc/          => [1, :escape, :carriage,          EscapeSequence::Return],
    /a\tc/          => [1, :escape, :tab,               EscapeSequence::Tab],
    /a\vc/          => [1, :escape, :vertical_tab,      EscapeSequence::VerticalTab],

    # meta character escapes
    /a\.c/          => [1, :escape, :dot,               EscapeSequence::Literal],
    /a\?c/          => [1, :escape, :zero_or_one,       EscapeSequence::Literal],
    /a\*c/          => [1, :escape, :zero_or_more,      EscapeSequence::Literal],
    /a\+c/          => [1, :escape, :one_or_more,       EscapeSequence::Literal],
    /a\|c/          => [1, :escape, :alternation,       EscapeSequence::Literal],
    /a\(c/          => [1, :escape, :group_open,        EscapeSequence::Literal],
    /a\)c/          => [1, :escape, :group_close,       EscapeSequence::Literal],
    /a\{c/          => [1, :escape, :interval_open,     EscapeSequence::Literal],
    /a\}c/          => [1, :escape, :interval_close,    EscapeSequence::Literal],

    # unicode escapes
    /a\u0640/       => [1, :escape, :codepoint,         EscapeSequence::Codepoint],
    /a\u{41 1F60D}/ => [1, :escape, :codepoint_list,    EscapeSequence::CodepointList],
    /a\u{10FFFF}/   => [1, :escape, :codepoint_list,    EscapeSequence::CodepointList],

     # hex escapes
    /a\xFF/n        => [1, :escape, :hex,               EscapeSequence::Hex],

    # octal escapes
    /a\177/n        => [1, :escape, :octal,             EscapeSequence::Octal],
  }

  tests.each_with_index do |(pattern, (index, type, token, klass)), count|
    specify("parse_escape_#{token}_#{count = (count + 1)}") do
      root = RP.parse(pattern, 'ruby/1.9')
      exp = root.expressions.at(index)

      expect(exp).to be_a(klass)

      expect(exp.type).to eq type
      expect(exp.token).to eq token
    end
  end

  specify('parse chars and codepoints') do
    root = RP.parse(/\n\?\101\x42\u0043\u{44 45}/)

    expect(root[0].char).to eq "\n"
    expect(root[0].codepoint).to eq 10

    expect(root[1].char).to eq '?'
    expect(root[1].codepoint).to eq 63

    expect(root[2].char).to eq 'A'
    expect(root[2].codepoint).to eq 65

    expect(root[3].char).to eq 'B'
    expect(root[3].codepoint).to eq 66

    expect(root[4].char).to eq 'C'
    expect(root[4].codepoint).to eq 67

    expect(root[5].chars).to eq %w[D E]
    expect(root[5].codepoints).to eq [68, 69]
  end

  specify('parse escape control sequence lower') do
    root = RP.parse(/a\\\c2b/)

    expect(root[2]).to be_instance_of(EscapeSequence::Control)
    expect(root[2].text).to eq '\\c2'
    expect(root[2].char).to eq "\x12"
    expect(root[2].codepoint).to eq 18
  end

  specify('parse escape control sequence upper') do
    root = RP.parse(/\d\\\C-C\w/)

    expect(root[2]).to be_instance_of(EscapeSequence::Control)
    expect(root[2].text).to eq '\\C-C'
    expect(root[2].char).to eq "\x03"
    expect(root[2].codepoint).to eq 3
  end

  specify('parse escape meta sequence') do
    root = RP.parse(/\Z\\\M-Z/n)

    expect(root[2]).to be_instance_of(EscapeSequence::Meta)
    expect(root[2].text).to eq '\\M-Z'
    expect(root[2].char).to eq "\u00DA"
    expect(root[2].codepoint).to eq 218
  end

  specify('parse escape meta control sequence') do
    root = RP.parse(/\A\\\M-\C-X/n)

    expect(root[2]).to be_instance_of(EscapeSequence::MetaControl)
    expect(root[2].text).to eq '\\M-\\C-X'
    expect(root[2].char).to eq "\u0098"
    expect(root[2].codepoint).to eq 152
  end

  specify('parse lower c meta control sequence') do
    root = RP.parse(/\A\\\M-\cX/n)

    expect(root[2]).to be_instance_of(EscapeSequence::MetaControl)
    expect(root[2].text).to eq '\\M-\\cX'
    expect(root[2].char).to eq "\u0098"
    expect(root[2].codepoint).to eq 152
  end

  specify('parse escape reverse meta control sequence') do
    root = RP.parse(/\A\\\C-\M-X/n)

    expect(root[2]).to be_instance_of(EscapeSequence::MetaControl)
    expect(root[2].text).to eq '\\C-\\M-X'
    expect(root[2].char).to eq "\u0098"
    expect(root[2].codepoint).to eq 152
  end

  specify('parse escape reverse lower c meta control sequence') do
    root = RP.parse(/\A\\\c\M-X/n)

    expect(root[2]).to be_instance_of(EscapeSequence::MetaControl)
    expect(root[2].text).to eq '\\c\\M-X'
    expect(root[2].char).to eq "\u0098"
    expect(root[2].codepoint).to eq 152
  end
end
