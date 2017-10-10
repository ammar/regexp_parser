require File.expand_path("../../helpers", __FILE__)

class ParserErrors < Test::Unit::TestCase
  def setup
    @rp = Regexp::Parser.new
    @rp.parse(/foo/)
  end

  def test_parser_unknown_token_type
    assert_raise( Regexp::Parser::UnknownTokenTypeError ) {
      @rp.__send__(:parse_token, Regexp::Token.new(:foo, :bar))
    }
  end

  def test_parser_unknown_set_token
    assert_raise( Regexp::Parser::UnknownTokenError ) {
      @rp.__send__(:parse_token, Regexp::Token.new(:set, :foo))
    }
  end

  def test_parser_unknown_meta_token
    assert_raise( Regexp::Parser::UnknownTokenError ) {
      @rp.__send__(:parse_token, Regexp::Token.new(:meta, :foo))
    }
  end

  def test_parser_unknown_character_type_token
    assert_raise( Regexp::Parser::UnknownTokenError ) {
      @rp.__send__(:parse_token, Regexp::Token.new(:type, :foo))
    }
  end

  def test_parser_unknown_unicode_property_token
    assert_raise( Regexp::Parser::UnknownTokenError ) {
      @rp.__send__(:parse_token, Regexp::Token.new(:property, :foo))
    }
  end

  def test_parser_unknown_unicode_nonproperty_token
    assert_raise( Regexp::Parser::UnknownTokenError ) {
      @rp.__send__(:parse_token, Regexp::Token.new(:nonproperty, :foo))
    }
  end

  def test_parser_unknown_anchor_token
    assert_raise( Regexp::Parser::UnknownTokenError ) {
      @rp.__send__(:parse_token, Regexp::Token.new(:anchor, :foo))
    }
  end

  def test_parser_unknown_quantifier_token
    assert_raise( Regexp::Parser::UnknownTokenError ) {
      @rp.__send__(:parse_token, Regexp::Token.new(:quantifier, :foo))
    }
  end

  def test_parser_unknown_group_open_token
    assert_raise( Regexp::Parser::UnknownTokenError ) {
      @rp.__send__(:parse_token, Regexp::Token.new(:group, :foo))
    }
  end

end
