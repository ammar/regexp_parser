# frozen_string_literal: true

require 'spec_helper'

ML = Regexp::MatchLength

RSpec.describe(Regexp::MatchLength) do
  specify('literal') { expect(ML.of(/a/).minmax).to eq [1, 1] }
  specify('literal sequence') { expect(ML.of(/abc/).minmax).to eq [3, 3] }
  specify('dot') { expect(ML.of(/./).minmax).to eq [1, 1] }
  specify('set') { expect(ML.of(/[abc]/).minmax).to eq [1, 1] }
  specify('type') { expect(ML.of(/\d/).minmax).to eq [1, 1] }
  specify('escape') { expect(ML.of(/\n/).minmax).to eq [1, 1] }
  specify('property') { expect(ML.of(/\p{ascii}/).minmax).to eq [1, 1] }
  specify('codepoint list') { expect(ML.of(/\u{61 62 63}/).minmax).to eq [3, 3] }
  specify('multi-char literal') { expect(ML.of(/abc/).minmax).to eq [3, 3] }
  specify('fixed quantified') { expect(ML.of(/a{5}/).minmax).to eq [5, 5] }
  specify('range quantified') { expect(ML.of(/a{5,9}/).minmax).to eq [5, 9] }
  specify('nested quantified') { expect(ML.of(/(a{2}){3,4}/).minmax).to eq [6, 8] }
  specify('open-end quantified') { expect(ML.of(/a*/).minmax).to eq [0, Float::INFINITY] }
  specify('empty subexpression') { expect(ML.of(//).minmax).to eq [0, 0] }
  specify('anchor') { expect(ML.of(/^$/).minmax).to eq [0, 0] }
  specify('lookaround') { expect(ML.of(/(?=abc)/).minmax).to eq [0, 0] }
  specify('free space') { expect(ML.of(/   /x).minmax).to eq [0, 0] }
  specify('comment') { expect(ML.of(/(?#comment)/x).minmax).to eq [0, 0] }
  specify('backreference') { expect(ML.of(/(abc){2}\1/).minmax).to eq [9, 9] }
  specify('fixed quantified backref') { expect(ML.of(/(a)\1{2}/).minmax).to eq [3, 3] }
  specify('range quantified backref') { expect(ML.of(/(ab)\1{2,4}/).minmax).to eq [6, 10] }
  specify('open-end quantified backref') { expect(ML.of(/(a)\1*/).minmax).to eq [1, Float::INFINITY] }
  specify('backref to alternation') { expect(ML.of(/(a|bb)\1{2}/).minmax).to eq [3, 6] }
  specify('multiplexed backref') { expect(ML.of(/(?:(?<x>a)|(?<x>bb))\k<x>/).minmax).to eq [2, 4] }
  specify('subexp call') { expect(ML.of(/(abc){2}\g<-1>/).minmax).to eq [9, 9] }
  specify('quantified subexp call') { expect(ML.of(/(ab){2}\g<1>{2}/).minmax).to eq [8, 8] }
  specify('alternation') { expect(ML.of(/a|bcde/).minmax).to eq [1, 4] }
  specify('nested alternation') { expect(ML.of(/a|bc(d|efg)/).minmax).to eq [1, 5] }
  specify('quantified alternation') { expect(ML.of(/a|bcde?/).minmax).to eq [1, 4] }
  if ruby_version_at_least('2.4.1')
    specify('absence group') { expect(ML.of('(?~abc)').minmax).to eq [0, Float::INFINITY] }
  end

  specify('raises for missing references') do
    exp = RP.parse(/(a)\1/).last
    exp.referenced_expressions = nil
    expect { exp.match_length }.to raise_error(ArgumentError)
  end

  describe('recursive references') do
    [
      '(?<a>a\g<a>?)',
      '(a\g<1>?)',
      'a\g<0>?',
      '(?<a>a\k<a>?)',
    ].each do |pattern|
      it "calculates bounds and lengths for #{pattern}" do
        length = ML.of(pattern)
        expect(length.minmax).to eq [1, Float::INFINITY]
        expect(length.first(5)).to eq [1, 2, 3, 4, 5]
      end
    end

    it 'allows repeated references to the same target' do
      expect(ML.of('(?<a>a)(?<b>\g<a>\g<a>)\g<b>').minmax).to eq [5, 5]
    end

    it 'does not follow references inside assertions' do
      expect(ML.of('(?<a>a(?=\g<a>))\g<a>').minmax).to eq [2, 2]
    end

    it 'preserves gaps introduced by recursion' do
      length = ML.of('(?<a>a(?:\g<a>aa)?)')
      expect(length.minmax).to eq [1, Float::INFINITY]
      expect(length.first(6)).to eq [1, 4, 7, 10, 13, 16]
      expect(length).not_to include 2
      expect(length).to include 100
      expect(length).not_to include 101
    end

    it 'finds a terminating alternative for a mandatory recursive call' do
      length = ML.of('(?<a>a\g<a>|aaa)')
      expect(length.minmax).to eq [3, Float::INFINITY]
      expect(length.first(4)).to eq [3, 4, 5, 6]
    end

    it 'handles mutual recursion' do
      length = ML.of('(?<a>a\g<b>?)(?<b>aa\g<a>?)')
      expect(length.minmax).to eq [3, Float::INFINITY]
      expect(length.first(8)).to eq [3, 4, 5, 6, 7, 8, 9, 10]
    end

    it 'handles more than one recursive call per branch' do
      length = ML.of('(?<a>a(?:\g<a>\g<a>)?)')
      expect(length.minmax).to eq [1, Float::INFINITY]
      expect(length.first(6)).to eq [1, 3, 5, 7, 9, 11]
    end

    it 'applies the referring expression and enclosing group quantifiers' do
      length = ML.of('(?<a>a(?:\g<a>aa)?){2}\g<a>{2}')
      expect(length.minmax).to eq [4, Float::INFINITY]
      expect(length.first(5)).to eq [4, 7, 10, 13, 16]
    end

    it 'works on a recursive call node directly' do
      call = RP.parse('(?<a>a\g<a>?)')[0][1]
      expect(call.match_length.minmax).to eq [0, Float::INFINITY]
      expect(call.match_length.first(4)).to eq [0, 1, 2, 3]
    end

    it 'handles zero-growth recursion without reporting an infinite maximum' do
      length = ML.of('(?<a>\g<a>|aa)')
      expect(length.minmax).to eq [2, 2]
      expect(length.to_a).to eq [2]
      expect(length).to be_fixed
    end

    it 'handles recursive expressions which only produce the empty string' do
      length = ML.of('(?<a>\g<a>?)')
      expect(length.minmax).to eq [0, 0]
      expect(length.to_a).to eq [0]
    end

    it 'keeps mutually recursive zero-growth alternatives finite' do
      length = ML.of('(?<a>\g<b>|a)(?<b>\g<a>|aa)')
      expect(length.minmax).to eq [2, 4]
      expect(length.to_a).to eq [2, 3, 4]
    end

    it 'handles nullable recursion that can also grow' do
      length = ML.of('(?<a>(?:aa\g<a>)?)')
      expect(length.minmax).to eq [0, Float::INFINITY]
      expect(length.first(5)).to eq [0, 2, 4, 6, 8]
    end

    it 'treats recursion without a terminating derivation as an empty length set' do
      length = ML.of('(?<a>a\g<a>)')
      expect(length.minmax).to eq [nil, nil]
      expect(length.to_a).to eq []
      expect(length.endless_each.to_a).to eq []
      expect(length).not_to be_fixed
      expect(length).not_to include 0
      expect(length).not_to include 10
    end

    it 'discards nonterminating alternatives when calculating bounds' do
      length = ML.of('(?<a>a\g<a>)|aa')
      expect(length.minmax).to eq [2, 2]
      expect(length.to_a).to eq [2]
    end

    it 'can skip a nonterminating expression' do
      length = ML.of('(?<a>a\g<a>)?')
      expect(length.minmax).to eq [0, 0]
      expect(length.to_a).to eq [0]
    end

    it 'ignores recursive branches quantified with zero repetitions' do
      length = ML.of('(?<a>a\g<a>{0})')
      expect(length.minmax).to eq [1, 1]
      expect(length.to_a).to eq [1]
    end

    it 'supports long matches without relying on the regexp engine recursion limit' do
      length = ML.of('(?<a>a\g<a>?)')
      expect(length).to include 3000
      expect(length.endless_each.first(1100)).to eq (1..1100).to_a
      expect(length.first(1100)).to eq (1..1000).to_a
    end

    describe('#to_re') do
      it 'can compose multiple conversions of the same recursive expression' do
        length = ML.of('(?<a>a(?:\g<a>aa)?)')
        regexp = /\A#{length.to_re}#{length.to_re}\z/
        expect(regexp).to match('X' * 2)
        expect(regexp).to match('X' * 5)
        expect(regexp).not_to match('X' * 3)
      end

      [
        '(?<a>a(?:\g<a>aa)?)',
        '(?<a>a\g<a>|aaa)',
        '(?<a>a(?:\g<a>\g<a>)?)',
        '(?<a>(?:aa\g<a>)?)',
        '(?<a>\g<a>|aa)',
        '(?<a>\g<a>?)',
        '(?<a>a\g<a>)',
        '(?<a>\g<a>aa|a)',
        '(?<a>\g<b>aa|a)(?<b>\g<a>aaa|aa)',
        '(?<a>\g<a>\g<a>|a)',
        '(?<a>(?:a|\g<a>)*)',
      ].each do |pattern|
        it "represents the length language of #{pattern}" do
          length = ML.of(pattern)
          regexp = /\A(?:#{length.to_re})\z/
          (0..20).each do |n|
            expect(!!regexp.match('X' * n)).to eq(length.include?(n)), "length #{n} of #{pattern}"
          end
        end
      end
    end

    describe('agreement with Ruby for consuming recursion') do
      [
        '(?<a>a\g<a>?)',
        '(?<a>a(?:\g<a>aa)?)',
        '(?<a>a\g<a>|aaa)',
        '(?<a>a\g<a>{2,3}|aa)',
        '(?<a>(?:aa\g<a>)?)',
        '(?<a>a\g<b>?)(?<b>aa\g<a>?)',
      ].each do |pattern|
        it "matches the attainable lengths of #{pattern}" do
          original = Regexp.new("\\A(?:#{pattern})\\z")
          length = ML.of(pattern)
          expected = (0..20).select { |n| original.match('a' * n) }
          expect((0..20).select { |n| length.include?(n) }).to eq expected
        end
      end
    end
  end

  specify('large finite quantifiers') do
    expect(ML.of('a{1000000,2000000}').minmax).to eq [1000000, 2000000]
  end

  specify('unbounded repetitions of a zero-length expression') do
    expect(ML.of('(?:)*').minmax).to eq [0, 0]
  end

  describe('::of') do
    it('works with Regexps') { expect(ML.of(/foo/).minmax).to eq [3, 3] }
    it('works with Strings') { expect(ML.of('foo').minmax).to eq [3, 3] }
    it('works with Expressions') { expect(ML.of(RP.parse(/foo/)).minmax).to eq [3, 3] }
  end

  describe('Expression::Base#match_length') do
    it('returns the MatchLength') { expect(RP.parse(/abc/).match_length.minmax).to eq [3, 3] }
  end

  describe('Expression::Base#inner_match_length') do
    it 'returns the MatchLength of an expression that does not count towards parent match_length' do
      exp = RP.parse(/(?=ab|cdef)/)[0]
      expect(exp).to be_a Regexp::Expression::Assertion::Base
      expect(exp.match_length.minmax).to eq [0, 0]
      expect(exp.inner_match_length.minmax).to eq [2, 4]
    end

    it 'handles recursive references inside an assertion' do
      exp = RP.parse('(?=(?<a>a(?:\g<a>aa)?))')[0]
      expect(exp.match_length.minmax).to eq [0, 0]
      expect(exp.inner_match_length.minmax).to eq [1, Float::INFINITY]
      expect(exp.inner_match_length.first(4)).to eq [1, 4, 7, 10]
    end
  end

  describe('#to_re') do
    ['abc', 'a{2,5}', '(?:aa)*', '(?:a?)*', '(?:aa|aaaa){2}', '(a)\1{2}'].each do |pattern|
      it "represents the lengths of #{pattern}" do
        length = ML.of(pattern)
        regexp = /\A(?:#{length.to_re})\z/
        (0..15).each do |n|
          expect(!!regexp.match('X' * n)).to eq length.include?(n)
        end
      end
    end
  end

  describe('#include?') do
    specify('unquantified') do
      expect(ML.of(/a/)).to include 1
      expect(ML.of(/a/)).not_to include 0
      expect(ML.of(/a/)).not_to include 2
    end

    specify('fixed quantified') do
      expect(ML.of(/a{5}/)).to include 5
      expect(ML.of(/a{5}/)).not_to include 0
      expect(ML.of(/a{5}/)).not_to include 4
      expect(ML.of(/a{5}/)).not_to include 6
    end

    specify('variably quantified') do
      expect(ML.of(/a?/)).to include 0
      expect(ML.of(/a?/)).to include 1
      expect(ML.of(/a?/)).not_to include 2
    end

    specify('nested quantified') do
      expect(ML.of(/(a{2}){3,4}/)).to include 6
      expect(ML.of(/(a{2}){3,4}/)).to include 8
      expect(ML.of(/(a{2}){3,4}/)).not_to include 0
      expect(ML.of(/(a{2}){3,4}/)).not_to include 5
      expect(ML.of(/(a{2}){3,4}/)).not_to include 7
      expect(ML.of(/(a{2}){3,4}/)).not_to include 9
    end

    specify('branches') do
      expect(ML.of(/ab|cdef/)).to include 2
      expect(ML.of(/ab|cdef/)).to include 4
      expect(ML.of(/ab|cdef/)).not_to include 0
      expect(ML.of(/ab|cdef/)).not_to include 3
      expect(ML.of(/ab|cdef/)).not_to include 5
    end

    specify('called on leaf node') do
      expect(ML.of(RP.parse(/a{2}/)[0])).to include 2
      expect(ML.of(RP.parse(/a{2}/)[0])).not_to include 0
      expect(ML.of(RP.parse(/a{2}/)[0])).not_to include 1
      expect(ML.of(RP.parse(/a{2}/)[0])).not_to include 3
    end
  end

  describe('#fixed?') do
    specify('unquantified') { expect(ML.of(/a/)).to be_fixed }
    specify('fixed quantified') { expect(ML.of(/a{5}/)).to be_fixed }
    specify('variably quantified') { expect(ML.of(/a?/)).not_to be_fixed }
    specify('equal branches') { expect(ML.of(/ab|cd/)).to be_fixed }
    specify('unequal branches') { expect(ML.of(/ab|cdef/)).not_to be_fixed }
    specify('equal quantified branches') { expect(ML.of(/a{2}|cd/)).to be_fixed }
    specify('unequal quantified branches') { expect(ML.of(/a{3}|cd/)).not_to be_fixed }
    specify('empty') { expect(ML.of(//)).to be_fixed }
  end

  describe('#each') do
    it 'returns an Enumerator if called without a block' do
      result = ML.of(/a?/).each
      expect(result).to be_a(Enumerator)
      expect(result.next).to eq 0
      expect(result.next).to eq 1
      expect { result.next }.to raise_error(StopIteration)
    end

    it 'is aware of limit option even if called without a block' do
      result = ML.of(/a?/).each(limit: 1)
      expect(result).to be_a(Enumerator)
      expect(result.next).to eq 0
      expect { result.next }.to raise_error(StopIteration)
    end

    it 'is limited to 1000 iterations in case there are infinite match lengths' do
      expect(ML.of(/a*/).first(3000).size).to eq 1000
    end

    it 'scaffolds the Enumerable interface' do
      expect(ML.of(/abc|defg/).count).to eq 2
      expect(ML.of(/(ab)*/).first(5)).to eq [0, 2, 4, 6, 8]
      expect(ML.of(/a{,10}/).any? { |len| len > 20 }).to be false
    end
  end

  describe('#endless_each') do
    it 'returns an Enumerator if called without a block' do
      result = ML.of(/a?/).endless_each
      expect(result).to be_a(Enumerator)
      expect(result.next).to eq 0
      expect(result.next).to eq 1
      expect { result.next }.to raise_error(StopIteration)
    end

    it 'never stops iterating for infinite match lengths' do
      expect(ML.of(/a*/).endless_each.first(3000).size).to eq 3000
    end
  end

  describe('#inspect') do
    it 'is nice' do
      result = RP.parse(/a{2,4}/)[0].match_length
      expect(result.inspect).to eq '#<Regexp::MatchLength<Literal> min=2 max=4>'
    end
  end
end
