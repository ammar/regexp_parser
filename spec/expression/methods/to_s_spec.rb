# frozen_string_literal: true

require 'spec_helper'

RSpec.describe('Expression::Base#to_s') do
  def parse_frozen(pattern)
    Leto.deep_freeze(RP.parse(pattern))
  end

  def expect_round_trip(pattern)
    parsed = parse_frozen(pattern)

    expect(parsed.to_s).to eql(pattern)
  end

  specify('literal alternation') do
    expect_round_trip('abcd|ghij|klmn|pqur')
  end

  specify('quantified alternations') do
    expect_round_trip('(?:a?[b]+(c){2}|d+[e]*(f)?)|(?:g+[h]?(i){2,3}|j*[k]{3,5}(l)?)')
  end

  specify('quantified sets') do
    expect_round_trip('[abc]+|[^def]{3,6}')
  end

  specify('property sets') do
    expect_round_trip('[\a\b\p{Lu}\P{Z}\c\d]+')
  end

  specify('groups') do
    expect_round_trip("(a(?>b(?:c(?<n>d(?'N'e)??f)+g)*+h)*i)++")
  end

  specify('assertions') do
    expect_round_trip('(a+(?=b+(?!c+(?<=d+(?<!e+)?f+)?g+)?h+)?i+)?')
  end

  specify('comments') do
    expect_round_trip('(?#start)a(?#middle)b(?#end)')
  end

  specify('options') do
    expect_round_trip('(?mix:start)a(?-mix:middle)b(?i-mx:end)')
  end

  specify('url') do
    expect_round_trip('(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*' + '\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)')
  end

  specify('multiline source') do
    multiline = /
          \A
          a?      # One letter
          b{2,5}  # Another one
          [c-g]+  # A set
          \z
        /x

    expect(parse_frozen(multiline).to_s).to eql(multiline.source)
  end

  specify('multiline #to_s') do
    multiline = /
          \A
          a?      # One letter
          b{2,5}  # Another one
          [c-g]+  # A set
          \z
        /x

    expect_round_trip(multiline.to_s)
  end

  specify('multiline with free space before quantifiers') do
    multiline = /
          \A
          a   ?             # One letter
          b {2,5}           # Another one
          [c-g]  +          # A set
          |                 #
          [h-j]  +          (?# Extra test for Sequence#quantify )
          [k-l] (?# hi! ) + # comment before quantifier
          \z
        /x

    expect_round_trip(multiline.to_s)
  end

  specify('multiline with nested quantifiers') do
    multiline = /
          a  {2}
          a  {2}  {2}
        /x

    expect_round_trip(multiline.to_s)
  end

  specify('formats decorated chained quantifiers') do
    root = parse_frozen('(?x)a (?#inner) + (?#outer) {2}')
    group = root[1]
    literal = group[0]

    expect(group.to_s(:base)).to eql('a (?#inner) +')
    expect(group.to_s(:full)).to eql('a (?#inner) +{2}')
    expect(group.to_s(:original)).to eql('a (?#inner) + (?#outer) {2}')
    expect(literal.to_s(:base)).to eql('a')
    expect(literal.to_s(:full)).to eql('a+')
    expect(literal.to_s(:original)).to eql('a (?#inner) +')
  end

  specify('regexp with all features') do
    expect_round_trip(regexp_with_all_features.source)
  end

  # special case: implicit groups used for chained quantifiers produce no parens
  specify 'chained quantifiers #to_s' do
    pattern = /a+{1}{2}/
    root = parse_frozen(pattern)
    expect(root.to_s).to eql('a+{1}{2}')
  end

  # regression test for https://github.com/ammar/regexp_parser/issues/74
  specify('non-ascii comment') do
    pattern = '(?x) 😋 # 😋'
    root = RP.parse(pattern)
    expect(root.last).to be_a(RE::Comment)
    expect(root.last.to_s).to eql('# 😋')
    expect(root.to_s).to eql(pattern)
  end
end
