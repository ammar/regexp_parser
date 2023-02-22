require 'spec_helper'

RSpec.describe('Expression::Shared#inspect') do
  it 'includes only essential information' do
    root = Regexp::Parser.parse(//)
    expect(root.inspect).to eq '#<Regexp::Expression::Root @expressions=[]>'

    root = Regexp::Parser.parse(/(a)+/)
    expect(root.inspect)
      .to match(/#<Regexp::Expression::Root @expressions=\[.+\]/)
    expect(root[0].inspect)
      .to match(/#<Regexp::Expression::Group::Capture @text=.+ @quantifier=.+ @expressions=\[.+\]/)
    expect(root[0].quantifier.inspect)
      .to eq    '#<Regexp::Expression::Quantifier @text="+">'
    expect(root[0][0].inspect)
      .to eq    '#<Regexp::Expression::Literal @text="a">'
  end
end

RSpec.describe('Expression::Shared#pretty_print') do
  it 'works' do
    require 'pp' # rubocop:disable Lint/RedundantRequireStatement
    pp_to_s = ->(arg) { ''.dup.tap { |buffer| PP.new(buffer).pp(arg) } }

    root = Regexp::Parser.parse(/(a)+/)

    expect(pp_to_s.(root)).to               start_with '#<Regexp::Expression::Root'
    expect(pp_to_s.(root[0])).to            start_with '#<Regexp::Expression::Group'
    expect(pp_to_s.(root[0].quantifier)).to start_with '#<Regexp::Expression::Quantifier'
    expect(pp_to_s.(root[0][0])).to         start_with '#<Regexp::Expression::Literal'
  end
end
