require 'spec_helper'

RSpec.describe('UnicodeScript scanning') do
  tests = {
    'Aghb'	                  => :caucasian_albanian,
    'Caucasian Albanian'	    => :caucasian_albanian,

    'Arab'	                  => :arabic,
    'Arabic'	                => :arabic,

    'Armi'	                  => :imperial_aramaic,
    'Imperial Aramaic'        => :imperial_aramaic,

    'Egyp'                    => :egyptian_hieroglyphs,
    'Egyptian Hieroglyphs'    => :egyptian_hieroglyphs, # test whitespace

    'Linb'                    => :linear_b,
    'Linear-B'                => :linear_b, # test dash

    'Yiii'                    => :yi,
    'Yi'                      => :yi,

    'Zinh'                    => :inherited,
    'Inherited'               => :inherited,
    'Qaai'                    => :inherited,

    'Zyyy'                    => :common,
    'Common'                  => :common,

    'Zzzz'                    => :unknown,
    'Unknown'                 => :unknown,
  }

  tests.each_with_index do |(property, token), count|
    specify("scanner_property_#{token}_#{count}") do
      tokens = RS.scan("a\\p{#{property}}c")
      result = tokens.at(1)
      expect(result[0]).to eq :property
      expect(result[1]).to eq token
    end

    specify("scanner_nonproperty_#{token}_#{count}") do
      tokens = RS.scan("a\\P{#{property}}c")
      result = tokens.at(1)
      expect(result[0]).to eq :nonproperty
      expect(result[1]).to eq token
    end
  end
end
