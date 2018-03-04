require File.expand_path("../../helpers", __FILE__)

class ScannerUnicodeEmojis < Test::Unit::TestCase

  tests = {
    'Emoji'               => :emoji_any,
    'Emoji_Component'     => :emoji_component,
    'Emoji_Modifier'      => :emoji_modifier,
    'Emoji_Modifier_Base' => :emoji_modifier_base,
    'Emoji_Presentation'  => :emoji_presentation,
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
