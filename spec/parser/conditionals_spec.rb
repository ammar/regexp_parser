require 'spec_helper'

RSpec.describe('Conditional parsing') do
  include_examples 'parse', /(?<A>a)(?(<A>)T|F)/,
    [1]       => [:conditional, :open, Conditional::Expression, to_s: '(?(<A>)T|F)', reference: 'A'],
    [1, 0]    => [:conditional, :condition, Conditional::Condition, to_s: '(<A>)', reference: 'A'],
    [1, 1]    => [:expression,  :sequence,  Conditional::Branch, to_s: 'T'],
    [1, 1, 0] => [:literal, text: 'T'],
    [1, 2]    => [:expression,  :sequence,  Conditional::Branch, to_s: 'F'],
    [1, 2, 0] => [:literal, text: 'F']

  include_examples 'parse', /(a)(?(1)T|F)/,
    [1]       => [:conditional, :open, Conditional::Expression, to_s: '(?(1)T|F)', reference: 1],
    [1, 0]    => [:conditional, :condition, Conditional::Condition, to_s: '(1)', reference: 1],
    [1, 1]    => [:expression,  :sequence,  Conditional::Branch, to_s: 'T'],
    [1, 1, 0] => [:literal, text: 'T'],
    [1, 2]    => [:expression,  :sequence,  Conditional::Branch, to_s: 'F'],
    [1, 2, 0] => [:literal, text: 'F']

  include_examples 'parse', /(foo)(?(1)\d+|(\w)){42}/,
    [1]       => [Conditional::Expression, quantified?: true, to_s: '(?(1)\d+|(\w)){42}'],
    [1, 0]    => [Conditional::Condition, quantified?: false],
    [1, 1]    => [Conditional::Branch, quantified?: false],
    [1, 1, 0] => [:digit, quantified?: true, to_s: '\d+'],
    [1, 2]    => [Conditional::Branch, quantified?: false]

  # test nested and mixed with alternations
  include_examples 'parse', <<-EOS.gsub(/\s/, ''),
      (
        (a)
        |
        (b)
        |
        (
          (
            ?(2)
            (c(d|e)+)?
            |
            (
              ?(3)
              f
              |
              (
                ?(4)
                (g|(h)(i))
              )
            )
          )
        )
      )
    EOS
    [0]                         => [Group::Capture, count: 1],
    [0, 0]                      => [Alternation, count: 3],
    [0, 0, 2]                   => [Alternative, count: 1],
    [0, 0, 2, 0]                => [Group::Capture, count: 1],
    [0, 0, 2, 0, 0]             => [Conditional::Expression, count: 3, conditional_level: 0],
    [0, 0, 2, 0, 0, 0]          => [Conditional::Condition, to_s: '(2)', conditional_level: 1],
    [0, 0, 2, 0, 0, 1]          => [Conditional::Branch, to_s: '(c(d|e)+)?', conditional_level: 1],
    [0, 0, 2, 0, 0, 2]          => [Conditional::Branch, to_s: '(?(3)f|(?(4)(g|(h)(i))))', conditional_level: 1],
    [0, 0, 2, 0, 0, 2, 0]       => [Conditional::Expression, count: 3, conditional_level: 1],
    [0, 0, 2, 0, 0, 2, 0, 0]    => [Conditional::Condition, to_s: '(3)', conditional_level: 2],
    [0, 0, 2, 0, 0, 2, 0, 1]    => [Conditional::Branch, count: 1, to_s: 'f', conditional_level: 2],
    [0, 0, 2, 0, 0, 2, 0, 1, 0] => [Literal, text: 'f', conditional_level: 2]

  # test empty branch
  include_examples 'parse', /(?<A>a)(?(<A>)T|)/,
    [1]    => [Conditional::Expression, count: 3, to_s: '(?(<A>)T|)'],
    [1, 2] => [Conditional::Branch, to_s: '']
end
