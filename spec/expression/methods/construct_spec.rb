require 'spec_helper'

RSpec.describe(Regexp::Expression::Shared) do
  describe '::construct' do
    {
      Alternation                       => :meta,
      Alternative                       => :expression,
      Anchor::Base                      => :anchor,
      Anchor::EndOfLine                 => :anchor,
      Assertion::Base                   => :assertion,
      Assertion::Lookahead              => :assertion,
      Backreference::Base               => :backref,
      Backreference::Number             => :backref,
      CharacterSet                      => :set,
      CharacterSet::IntersectedSequence => :expression,
      CharacterSet::Intersection        => :set,
      CharacterSet::Range               => :set,
      CharacterType::Any                => :meta,
      CharacterType::Base               => :type,
      CharacterType::Digit              => :type,
      Conditional::Branch               => :expression,
      Conditional::Condition            => :conditional,
      Conditional::Expression           => :conditional,
      EscapeSequence::Base              => :escape,
      EscapeSequence::Literal           => :escape,
      FreeSpace                         => :free_space,
      Group::Base                       => :group,
      Group::Capture                    => :group,
      Keep::Mark                        => :keep,
      Literal                           => :literal,
      PosixClass                        => :posixclass,
      Quantifier                        => :quantifier,
      Root                              => :expression,
      UnicodeProperty::Base             => :property,
      UnicodeProperty::Number::Decimal  => :property,
    }.each do |klass, expected_type|
      it "works for #{klass}" do
        result = klass.construct
        expect(result).to be_a klass
        expect(result.type).to eq expected_type
      end
    end

    it 'allows overriding defaults' do
      expect(Literal.construct(type: :foo).type).to eq :foo
    end

    it 'allows passing options' do
      expect(Literal.construct(options: { i: true }).options[:i]).to eq true
    end

    it 'raises ArgumentError for unknown parameters' do
      expect { Literal.construct(foo: :foo) }.to raise_error(ArgumentError)
    end
  end
end
