# frozen_string_literal: true

require 'spec_helper'

RSpec.describe('Quantifier scanning') do
  include_examples 'scan', 'a?',       1 => [:quantifier,  :zero_or_one,             '?',     1, 2]
  include_examples 'scan', 'a??',      1 => [:quantifier,  :zero_or_one_reluctant,   '??',    1, 3]
  include_examples 'scan', 'a?+',      1 => [:quantifier,  :zero_or_one_possessive,  '?+',    1, 3]

  include_examples 'scan', 'a*',       1 => [:quantifier,  :zero_or_more,            '*',     1, 2]
  include_examples 'scan', 'a*?',      1 => [:quantifier,  :zero_or_more_reluctant,  '*?',    1, 3]
  include_examples 'scan', 'a*+',      1 => [:quantifier,  :zero_or_more_possessive, '*+',    1, 3]

  include_examples 'scan', 'a+',       1 => [:quantifier,  :one_or_more,             '+',     1, 2]
  include_examples 'scan', 'a+?',      1 => [:quantifier,  :one_or_more_reluctant,   '+?',    1, 3]
  include_examples 'scan', 'a++',      1 => [:quantifier,  :one_or_more_possessive,  '++',    1, 3]

  include_examples 'scan', 'a{2}',     1 => [:quantifier,  :interval,                '{2}',   1, 4]
  include_examples 'scan', 'a{2,}',    1 => [:quantifier,  :interval,                '{2,}',  1, 5]
  include_examples 'scan', 'a{,2}',    1 => [:quantifier,  :interval,                '{,2}',  1, 5]
  include_examples 'scan', 'a{2,4}',   1 => [:quantifier,  :interval,                '{2,4}', 1, 6]

  # special case: chained quantifiers.
  # Ruby does not support any modes for *exact* interval quantifiers,
  # and only lazy mode for non-exact interval quantifiers.
  # As a result, + is always and ? is sometimes treated as a chained quantifier.
  include_examples 'scan', 'a+{2}{3}', 1 => [:quantifier,  :one_or_more,             '+',     1, 2],
                                       2 => [:quantifier,  :interval,                '{2}',   2, 5],
                                       3 => [:quantifier,  :interval,                '{3}',   5, 8]
  include_examples 'scan', 'aa{2}?',   1 => [:quantifier,  :interval,                '{2}',   2, 5],
                                       2 => [:quantifier,  :zero_or_one,             '?',     5, 6]
  include_examples 'scan', 'aa{2}*',   1 => [:quantifier,  :interval,                '{2}',   2, 5],
                                       2 => [:quantifier,  :zero_or_more,            '*',     5, 6]
  include_examples 'scan', 'aa{2}+',   1 => [:quantifier,  :interval,                '{2}',   2, 5],
                                       2 => [:quantifier,  :one_or_more,             '+',     5, 6]
  include_examples 'scan', 'aa{2,3}?', 1 => [:quantifier,  :interval_reluctant,      '{2,3}?', 2, 8]
  include_examples 'scan', 'aa{2,3}*', 1 => [:quantifier,  :interval,                '{2,3}', 2, 7],
                                       2 => [:quantifier,  :zero_or_more,            '*',     7, 8]
  include_examples 'scan', 'aa{2,3}+', 1 => [:quantifier,  :interval,                '{2,3}', 2, 7],
                                       2 => [:quantifier,  :one_or_more,             '+',     7, 8]
  include_examples 'scan', 'aa{2,}?',  1 => [:quantifier,  :interval_reluctant,      '{2,}?', 2, 7]
  include_examples 'scan', 'aa{2,}*',  1 => [:quantifier,  :interval,                '{2,}',  2, 6],
                                       2 => [:quantifier,  :zero_or_more,            '*',     6, 7]
  include_examples 'scan', 'aa{2,}+',  1 => [:quantifier,  :interval,                '{2,}',  2, 6],
                                       2 => [:quantifier,  :one_or_more,             '+',     6, 7]
  include_examples 'scan', 'aa{,3}?',  1 => [:quantifier,  :interval_reluctant,      '{,3}?', 2, 7]
  include_examples 'scan', 'aa{,3}*',  1 => [:quantifier,  :interval,                '{,3}',  2, 6],
                                       2 => [:quantifier,  :zero_or_more,            '*',     6, 7]
  include_examples 'scan', 'aa{,3}+',  1 => [:quantifier,  :interval,                '{,3}',  2, 6],
                                       2 => [:quantifier,  :one_or_more,             '+',     6, 7]

  # ensure that the above quirks remain ruby's behavior
  specify('ruby quirks') do
    expect(/ab{2}?a/).to match 'aa'
    expect(/ab{2,3}?a/).not_to match 'aa'
    expect(/ab{2}+a/).to match 'abbbba'
    expect(/ab{2,3}+a/).to match 'abbbba'
  end
end
