require 'spec_helper'

RSpec.describe('RefCall lexing') do
  tests = {
    # Traditional numerical group back-reference
    '(abc)\1'           => [3, :backref, :number,                '\1',         5,  7, 0, 0, 0],

    # Group back-references, named, numbered, and relative
    '(?<X>abc)\k<X>'    => [3, :backref, :name_ref,              '\k<X>',      9, 14, 0, 0, 0],
    "(?<X>abc)\\k'X'"   => [3, :backref, :name_ref,              "\\k'X'",     9, 14, 0, 0, 0],

    '(abc)\k<1>'        => [3, :backref, :number_ref,            '\k<1>',      5, 10, 0, 0, 0],
    "(abc)\\k'1'"       => [3, :backref, :number_ref,            "\\k'1'",     5, 10, 0, 0, 0],

    '(abc)\k<-1>'       => [3, :backref, :number_rel_ref,        '\k<-1>',     5, 11, 0, 0, 0],
    "(abc)\\k'-1'"      => [3, :backref, :number_rel_ref,        "\\k'-1'",    5, 11, 0, 0, 0],

    # Sub-expression invocation, named, numbered, and relative
    '(?<X>abc)\g<X>'    => [3, :backref, :name_call,             '\g<X>',      9, 14, 0, 0, 0],
    "(?<X>abc)\\g'X'"   => [3, :backref, :name_call,             "\\g'X'",     9, 14, 0, 0, 0],

    '(abc)\g<1>'        => [3, :backref, :number_call,           '\g<1>',      5, 10, 0, 0, 0],
    "(abc)\\g'1'"       => [3, :backref, :number_call,           "\\g'1'",     5, 10, 0, 0, 0],

    '(abc)\g<-1>'       => [3, :backref, :number_rel_call,       '\g<-1>',     5, 11, 0, 0, 0],
    "(abc)\\g'-1'"      => [3, :backref, :number_rel_call,       "\\g'-1'",    5, 11, 0, 0, 0],

    '(abc)\g<+1>'       => [3, :backref, :number_rel_call,       '\g<+1>',     5, 11, 0, 0, 0],
    "(abc)\\g'+1'"      => [3, :backref, :number_rel_call,       "\\g'+1'",    5, 11, 0, 0, 0],

    # Group back-references, with nesting level
    '(?<X>abc)\k<X-0>'  => [3, :backref, :name_recursion_ref,    '\k<X-0>',    9, 16, 0, 0, 0],
    "(?<X>abc)\\k'X-0'" => [3, :backref, :name_recursion_ref,    "\\k'X-0'",   9, 16, 0, 0, 0],

    '(abc)\k<1-0>'      => [3, :backref, :number_recursion_ref,  '\k<1-0>',    5, 12, 0, 0, 0],
    "(abc)\\k'1-0'"     => [3, :backref, :number_recursion_ref,  "\\k'1-0'",   5, 12, 0, 0, 0],
  }

  tests.each_with_index do |(pattern, (index, type, token, text, ts, te, level, set_level, conditional_level)), count|
    specify("lexer_#{type}_#{token}_#{count}") do
      tokens = RL.lex(pattern, 'ruby/1.9')
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
