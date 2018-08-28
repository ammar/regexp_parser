require File.expand_path("../../helpers", __FILE__)

class ScannerUnicodeScripts < Test::Unit::TestCase

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
    define_method "test_scanner_property_#{token}_#{count}" do
      tokens = RS.scan("a\\p{#{property}}c")
      result = tokens.at(1)

      assert_equal :property, result[0]
      assert_equal token,     result[1]
    end

    define_method "test_scanner_nonproperty_#{token}_#{count}" do
      tokens = RS.scan("a\\P{#{property}}c")
      result = tokens.at(1)

      assert_equal :nonproperty, result[0]
      assert_equal token,        result[1]
    end
  end

end
