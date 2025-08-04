# frozen_string_literal: true

require 'spec_helper'

RSpec.describe('RefCall scanning') do
  # Traditional numerical group back-reference.
  # For non-matched cases see ./escapes_spec.rb
  include_examples 'scan', '(abc)\1' ,          3 => [:backref, :number, '\1',       5,   7]

  # They can have two or more digits:
  # "#{[*2..101].join}101"[/#{(2..101).map { |n| "(#{n})" }.join}\K\100/] # => '101'
  include_examples 'scan', '(((((((((())))))))))\10',
                                                -1 => [:backref, :number, '\10',     20,  23]
  include_examples 'scan', "#{[*1..100].map { |n| "(#{n})" }.join}\\100",
                                                -1 => [:backref, :number, '\100',   392, 396]

  # Double digit escapes are treated as backref as soon as a fitting group is open:
  # "\10"[/((((((((((\10))))))))))/] # => nil
  include_examples 'scan', '((((((((((\10))))))))))',
                                                10 => [:backref, :number, '\10',     10,  13]

  # Group back-references, named, numbered, and relative
  #
  # NOTE: only \g supports forward-looking references using '+', e.g. \g<+1>
  # refers to the next group, but \k<+1> refers to a group named '+1'.
  # Inversely, only \k supports addition or subtraction of a recursion level.
  # E.g. \k<x+0> refers to a group named 'x' at the current recursion level,
  # but \g<x+0> refers to a a group named 'x+0'.
  #
  include_examples 'scan', '(?<X>abc)\k<X>',    3 => [:backref, :name_ref_ab,             '\k<X>',      9, 14]
  include_examples 'scan', "(?<X>abc)\\k'X'",   3 => [:backref, :name_ref_sq,             "\\k'X'",     9, 14]

  include_examples 'scan', '(?<+1>abc)\k<+1>',  3 => [:backref, :name_ref_ab,             '\k<+1>',    10, 16]
  include_examples 'scan', "(?<+1>abc)\\k'+1'", 3 => [:backref, :name_ref_sq,             "\\k'+1'",   10, 16]

  include_examples 'scan', '(abc)\k<1>',        3 => [:backref, :number_ref_ab,           '\k<1>',      5, 10]
  include_examples 'scan', "(abc)\\k'1'",       3 => [:backref, :number_ref_sq,           "\\k'1'",     5, 10]
  include_examples 'scan', "(abc)\\k'001'",     3 => [:backref, :number_ref_sq,           "\\k'001'",   5, 12]

  include_examples 'scan', '(abc)\k<-1>',       3 => [:backref, :number_rel_ref_ab,       '\k<-1>',     5, 11]
  include_examples 'scan', "(abc)\\k'-1'",      3 => [:backref, :number_rel_ref_sq,       "\\k'-1'",    5, 11]
  include_examples 'scan', '(abc)\k<-001>',     3 => [:backref, :number_rel_ref_ab,       '\k<-001>',   5, 13]

  # Sub-expression invocation, named, numbered, and relative
  include_examples 'scan', '(?<X>abc)\g<X>',    3 => [:backref, :name_call_ab,            '\g<X>',      9, 14]
  include_examples 'scan', "(?<X>abc)\\g'X'",   3 => [:backref, :name_call_sq,            "\\g'X'",     9, 14]

  include_examples 'scan', '(?<X>abc)\g<X-1>',  3 => [:backref, :name_call_ab,            '\g<X-1>',    9, 16]
  include_examples 'scan', "(?<X>abc)\\g'X-1'", 3 => [:backref, :name_call_sq,            "\\g'X-1'",   9, 16]

  include_examples 'scan', '(abc)\g<1>',        3 => [:backref, :number_call_ab,          '\g<1>',      5, 10]
  include_examples 'scan', "(abc)\\g'1'",       3 => [:backref, :number_call_sq,          "\\g'1'",     5, 10]
  include_examples 'scan', '(abc)\g<001>',      3 => [:backref, :number_call_ab,          '\g<001>',    5, 12]

  include_examples 'scan', 'a(b|\g<0>)',        4 => [:backref, :number_call_ab,          '\g<0>',      4, 9]
  include_examples 'scan', "a(b|\\g'0')",       4 => [:backref, :number_call_sq,          "\\g'0'",     4, 9]

  include_examples 'scan', '(abc)\g<-1>',       3 => [:backref, :number_rel_call_ab,      '\g<-1>',     5, 11]
  include_examples 'scan', "(abc)\\g'-1'",      3 => [:backref, :number_rel_call_sq,      "\\g'-1'",    5, 11]
  include_examples 'scan', '(abc)\g<-001>',     3 => [:backref, :number_rel_call_ab,      '\g<-001>',   5, 13]

  include_examples 'scan', '\g<+1>(abc)',       0 => [:backref, :number_rel_call_ab,      '\g<+1>',     0, 6]
  include_examples 'scan', "\\g'+1'(abc)",      0 => [:backref, :number_rel_call_sq,      "\\g'+1'",    0, 6]

  # Group back-references, with recursion level
  include_examples 'scan', '(?<X>abc)\k<X-0>',  3 => [:backref, :name_recursion_ref_ab,   '\k<X-0>',    9, 16]
  include_examples 'scan', "(?<X>abc)\\k'X-0'", 3 => [:backref, :name_recursion_ref_sq,   "\\k'X-0'",   9, 16]

  include_examples 'scan', '(abc)\k<1-0>',      3 => [:backref, :number_recursion_ref_ab, '\k<1-0>',    5, 12]
  include_examples 'scan', "(abc)\\k'1-0'",     3 => [:backref, :number_recursion_ref_sq, "\\k'1-0'",   5, 12]

  include_examples 'scan', '(abc)\k<+1-0>',     3 => [:backref, :name_recursion_ref_ab,   '\k<+1-0>',   5, 13]
  include_examples 'scan', "(abc)\\k'+1-0'",    3 => [:backref, :name_recursion_ref_sq,   "\\k'+1-0'",  5, 13]
end
