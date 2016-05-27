require File.expand_path("../../helpers", __FILE__)

class ScannerRefCalls < Test::Unit::TestCase

  tests = {
    # Group back-references, named, numbered, and relative
    '(?<X>abc)\k<X>'    => [3, :backref, :name_ref_ab,          '\k<X>',      9, 14],
    "(?<X>abc)\\k'X'"   => [3, :backref, :name_ref_sq,          "\\k'X'",     9, 14],

    '(abc)\k<1>'        => [3, :backref, :number_ref_ab,        '\k<1>',      5, 10],
    "(abc)\\k'1'"       => [3, :backref, :number_ref_sq,        "\\k'1'",     5, 10],

    '(abc)\k<-1>'       => [3, :backref, :number_rel_ref_ab,    '\k<-1>',     5, 11],
    "(abc)\\k'-1'"      => [3, :backref, :number_rel_ref_sq,    "\\k'-1'",    5, 11],

    # Sub-expression invocation, named, numbered, and relative
    '(?<X>abc)\g<X>'    => [3, :backref, :name_call_ab,         '\g<X>',      9, 14],
    "(?<X>abc)\\g'X'"   => [3, :backref, :name_call_sq,         "\\g'X'",     9, 14],

    '(abc)\g<1>'        => [3, :backref, :number_call_ab,       '\g<1>',      5, 10],
    "(abc)\\g'1'"       => [3, :backref, :number_call_sq,       "\\g'1'",     5, 10],

    '(abc)\g<-1>'       => [3, :backref, :number_rel_call_ab,   '\g<-1>',     5, 11],
    "(abc)\\g'-1'"      => [3, :backref, :number_rel_call_sq,   "\\g'-1'",    5, 11],

    # Group back-references, with nesting level
    '(?<X>abc)\k<X-0>'  => [3, :backref, :name_nest_ref_ab,     '\k<X-0>',    9, 16],
    "(?<X>abc)\\k'X-0'" => [3, :backref, :name_nest_ref_sq,     "\\k'X-0'",   9, 16],

    '(abc)\k<1-0>'      => [3, :backref, :number_nest_ref_ab,   '\k<1-0>',    5, 12],
    "(abc)\\k'1-0'"     => [3, :backref, :number_nest_ref_sq,   "\\k'1-0'",   5, 12],
  }

  tests.each_with_index do |(pattern, (index, type, token, text, ts, te)), count|
    define_method "test_scanner_#{type}_#{token}_#{count}" do
      tokens = RS.scan(pattern)
      result = tokens[index]

      assert_equal type,  result[0]
      assert_equal token, result[1]
      assert_equal text,  result[2]
      assert_equal ts,    result[3]
      assert_equal te,    result[4]
      assert_equal text,  pattern[ts, te]
    end
  end

end
