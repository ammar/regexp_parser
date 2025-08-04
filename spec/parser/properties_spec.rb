# frozen_string_literal: true

require 'spec_helper'

RSpec.describe('Property parsing') do
  # test various notations supported by Ruby
  include_examples 'parse', '\p{sd}',           0 => [:property, :soft_dotted]
  include_examples 'parse', '\p{SD}',           0 => [:property, :soft_dotted]
  include_examples 'parse', '\p{Soft Dotted}',  0 => [:property, :soft_dotted]
  include_examples 'parse', '\p{Soft-Dotted}',  0 => [:property, :soft_dotted]
  include_examples 'parse', '\p{sOfT_dOtTeD}',  0 => [:property, :soft_dotted]

  # test ^-negation
  include_examples 'parse', '\p{^sd}',          0 => [:nonproperty, :soft_dotted]
  include_examples 'parse', '\p{^SD}',          0 => [:nonproperty, :soft_dotted]
  include_examples 'parse', '\p{^Soft Dotted}', 0 => [:nonproperty, :soft_dotted]
  include_examples 'parse', '\p{^Soft-Dotted}', 0 => [:nonproperty, :soft_dotted]
  include_examples 'parse', '\p{^sOfT_dOtTeD}', 0 => [:nonproperty, :soft_dotted]

  # test P-negation
  include_examples 'parse', '\P{sd}',           0 => [:nonproperty, :soft_dotted]
  include_examples 'parse', '\P{SD}',           0 => [:nonproperty, :soft_dotted]
  include_examples 'parse', '\P{Soft Dotted}',  0 => [:nonproperty, :soft_dotted]
  include_examples 'parse', '\P{Soft-Dotted}',  0 => [:nonproperty, :soft_dotted]
  include_examples 'parse', '\P{sOfT_dOtTeD}',  0 => [:nonproperty, :soft_dotted]

  # double negation is positive again
  include_examples 'parse', '\P{^sd}',          0 => [:property, :soft_dotted]
  include_examples 'parse', '\P{^SD}',          0 => [:property, :soft_dotted]
  include_examples 'parse', '\P{^Soft Dotted}', 0 => [:property, :soft_dotted]
  include_examples 'parse', '\P{^Soft-Dotted}', 0 => [:property, :soft_dotted]
  include_examples 'parse', '\P{^sOfT_dOtTeD}', 0 => [:property, :soft_dotted]

  # test #shortcut
  include_examples 'parse', '\p{soft_dotted}',  0 => [:property, :soft_dotted, shortcut: 'sd']
  include_examples 'parse', '\p{sd}',           0 => [:property, :soft_dotted, shortcut: 'sd']
  include_examples 'parse', '\p{in_bengali}',   0 => [:property, :in_bengali, shortcut: nil]

  # test classification
  include_examples 'parse', '\p{age=5.2}',                     0 => [UnicodeProperty::Age]
  include_examples 'parse', '\p{InArmenian}',                  0 => [UnicodeProperty::Block]
  include_examples 'parse', '\p{Math}',                        0 => [UnicodeProperty::Derived]
  include_examples 'parse', '\p{Emoji}',                       0 => [UnicodeProperty::Emoji]
  include_examples 'parse', '\p{GraphemeClusterBreak=Extend}', 0 => [UnicodeProperty::Enumerated]
  include_examples 'parse', '\p{Hiragana}',                    0 => [UnicodeProperty::Script]

  specify('parse abandoned newline property') do
    root = RP.parse('\p{newline}', 'ruby/1.9')
    expect(root.expressions.last).to be_a(UnicodeProperty::Base)

    expect { RP.parse('\p{newline}', 'ruby/2.0') }.to raise_error(Regexp::Syntax::NotImplementedError)
  end

  # cannot test older Rubies because of https://bugs.ruby-lang.org/issues/18686
  if ruby_version_at_least('3.2.0')
    specify('parse all properties of current ruby') do
      unsupported = RegexpPropertyValues.all_for_current_ruby.reject do |prop|
        RP.parse("\\p{#{prop}}") rescue false
      end
      expect(unsupported).to be_empty
    end
  end

  # Ruby 2.3 supports a short prop name (sterm) without supporting the long name
  # of the same prop (sentence_terminal). Let's ignore this unique case.
  if ruby_version_at_least('2.4.0')
    specify('parse only properties of current ruby') do
      syntax = Regexp::Syntax.for("ruby/#{RUBY_VERSION}")
      excessive = syntax.features.fetch(:property, []).reject do |prop|
        begin
          Regexp.new("\\p{#{prop}}")
        rescue RegexpError, SyntaxError # error class depends on Ruby version
          false
        end
      end
      expect(excessive).to be_empty
    end
  end
end
