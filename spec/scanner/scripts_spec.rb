require 'spec_helper'

RSpec.describe('UnicodeScript scanning') do
  include_examples 'scan property', 'Arab',	                    :arabic
  include_examples 'scan property', 'Arabic',	                  :arabic

  include_examples 'scan property', 'Egyp',                     :egyptian_hieroglyphs
  include_examples 'scan property', 'Egyptian Hieroglyphs',     :egyptian_hieroglyphs # test whitespace

  include_examples 'scan property', 'Linb',                     :linear_b
  include_examples 'scan property', 'Linear-B',                 :linear_b # test dash

  include_examples 'scan property', 'Yiii',                     :yi
  include_examples 'scan property', 'Yi',                       :yi

  include_examples 'scan property', 'Zinh',                     :inherited
  include_examples 'scan property', 'Inherited',                :inherited
  include_examples 'scan property', 'Qaai',                     :inherited

  include_examples 'scan property', 'Zyyy',                     :common
  include_examples 'scan property', 'Common',                   :common

  include_examples 'scan property', 'Zzzz',                     :unknown
  include_examples 'scan property', 'Unknown',                  :unknown
end
