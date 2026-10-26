# frozen_string_literal: true

require 'spec_helper'

RSpec.describe(Regexp::Expression::Shared) do
  describe '::construct' do
    {
      RE::Alternation                       => :meta,
      RE::Alternative                       => :expression,
      RE::Anchor::Base                      => :anchor,
      RE::Anchor::EndOfLine                 => :anchor,
      RE::Assertion::Base                   => :assertion,
      RE::Assertion::Lookahead              => :assertion,
      RE::Backreference::Base               => :backref,
      RE::Backreference::Number             => :backref,
      RE::CharacterSet                      => :set,
      RE::CharacterSet::IntersectedSequence => :expression,
      RE::CharacterSet::Intersection        => :set,
      RE::CharacterSet::Range               => :set,
      RE::CharacterType::Any                => :meta,
      RE::CharacterType::Base               => :type,
      RE::CharacterType::Digit              => :type,
      RE::Conditional::Branch               => :expression,
      RE::Conditional::Condition            => :conditional,
      RE::Conditional::Expression           => :conditional,
      RE::EscapeSequence::Base              => :escape,
      RE::EscapeSequence::Literal           => :escape,
      RE::FreeSpace                         => :free_space,
      RE::Group::Base                       => :group,
      RE::Group::Capture                    => :group,
      RE::Keep::Mark                        => :keep,
      RE::Literal                           => :literal,
      RE::PosixClass                        => :posixclass,
      RE::Quantifier                        => :quantifier,
      RE::Root                              => :expression,
      RE::UnicodeProperty::Base             => :property,
      RE::UnicodeProperty::Number::Decimal  => :property,
    }.each do |klass, expected_type|
      it "works for #{klass}" do
        result = klass.construct
        expect(result).to be_a klass
        expect(result.type).to eq expected_type
      end
    end

    it 'allows overriding defaults' do
      expect(RE::Literal.construct(type: :foo).type).to eq :foo
    end

    it 'allows passing options' do
      expect(RE::Literal.construct(options: { i: true }).options[:i]).to eq true
    end

    it 'raises ArgumentError for unknown parameters' do
      expect { RE::Literal.construct(foo: :foo) }.to raise_error(ArgumentError)
    end
  end
end
