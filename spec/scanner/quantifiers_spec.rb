require 'spec_helper'

RSpec.describe('Quantifier scanning') do
  tests = {
   'a?'     => [:quantifier,  :zero_or_one,             '?'],
   'a??'    => [:quantifier,  :zero_or_one_reluctant,   '??'],
   'a?+'    => [:quantifier,  :zero_or_one_possessive,  '?+'],

   'a*'     => [:quantifier,  :zero_or_more,            '*'],
   'a*?'    => [:quantifier,  :zero_or_more_reluctant,  '*?'],
   'a*+'    => [:quantifier,  :zero_or_more_possessive, '*+'],

   'a+'     => [:quantifier,  :one_or_more,             '+'],
   'a+?'    => [:quantifier,  :one_or_more_reluctant,   '+?'],
   'a++'    => [:quantifier,  :one_or_more_possessive,  '++'],

   'a{2}'   => [:quantifier,  :interval,                '{2}'],
   'a{2,}'  => [:quantifier,  :interval,                '{2,}'],
   'a{,2}'  => [:quantifier,  :interval,                '{,2}'],
   'a{2,4}' => [:quantifier,  :interval,                '{2,4}'],
  }

  tests.each_with_index do |(pattern, (type, token, text)), count|
    name = token == :interval ? "interval_#{count}" : token

    specify("scan_#{type}_#{name}") do
      tokens = RS.scan(pattern)
      result = tokens.last

      expect(result[0]).to eq type
      expect(result[1]).to eq token
      expect(result[2]).to eq text
    end
  end
end
