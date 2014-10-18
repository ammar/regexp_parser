require File.expand_path("../../helpers", __FILE__)

class LexerRefCalls < Test::Unit::TestCase

  tests = {
    # Group back-references, named, numbered, and relative
    '(?<X>abc)\k<X>'  => [3, :backref, :name_ref,           '\k<X>',      9, 14, 0, 0, 0],
    "(?<X>abc)\\k'X'" => [3, :backref, :name_ref,           "\\k'X'",     9, 14, 0, 0, 0],

    '(abc)\k<1>'      => [3, :backref, :number_ref,         '\k<1>',      5, 10, 0, 0, 0],
    "(abc)\\k'1'"     => [3, :backref, :number_ref,         "\\k'1'",     5, 10, 0, 0, 0],

    '(abc)\k<-1>'     => [3, :backref, :number_rel_ref,     '\k<-1>',     5, 11, 0, 0, 0],
    "(abc)\\k'-1'"    => [3, :backref, :number_rel_ref,     "\\k'-1'",    5, 11, 0, 0, 0],

    # Sub-expression invocation, named, numbered, and relative
    '(?<X>abc)\g<X>'  => [3, :backref, :name_call,          '\g<X>',      9, 14, 0, 0, 0],
    "(?<X>abc)\\g'X'" => [3, :backref, :name_call,          "\\g'X'",     9, 14, 0, 0, 0],

    '(abc)\g<1>'      => [3, :backref, :number_call,        '\g<1>',      5, 10, 0, 0, 0],
    "(abc)\\g'1'"     => [3, :backref, :number_call,        "\\g'1'",     5, 10, 0, 0, 0],

    '(abc)\g<-1>'     => [3, :backref, :number_rel_call,    '\g<-1>',     5, 11, 0, 0, 0],
    "(abc)\\g'-1'"    => [3, :backref, :number_rel_call,    "\\g'-1'",    5, 11, 0, 0, 0],

    # Group back-references, with nesting level
    '(?<X>abc)\k<X-0>'  => [3, :backref, :name_nest_ref,    '\k<X-0>',    9, 16, 0, 0, 0],
    "(?<X>abc)\\k'X-0'" => [3, :backref, :name_nest_ref,    "\\k'X-0'",   9, 16, 0, 0, 0],

    '(abc)\k<1-0>'      => [3, :backref, :number_nest_ref,  '\k<1-0>',    5, 12, 0, 0, 0],
    "(abc)\\k'1-0'"     => [3, :backref, :number_nest_ref,  "\\k'1-0'",   5, 12, 0, 0, 0],
  }

  count = 0
  tests.each do |pattern, test|
    define_method "test_lexer_#{test[1]}_#{test[2]}_#{count+=1}" do

      tokens = RL.lex(pattern, 'ruby/1.9')
      assert_equal( test[1,8], tokens[test[0]].to_a)
    end
  end

end
