require File.expand_path("../../helpers", __FILE__)

class TestSyntaxTokenMap < Test::Unit::TestCase
  def test_syntax_token_map_complete
    map = Regexp::Syntax::Token::Map
    latest_syntax = Regexp::Syntax.new 'ruby/2.9'

    latest_syntax.features.each do |type, tokens|
      tokens.each do |token|
        assert map[type].include?(token),
               "`#{type} #{token}` implemented but missing from Map"
      end
    end
  end

  def test_syntax_token_map_uniq
    combinations = Regexp::Syntax::Token::Map.flat_map do |type, tokens|
      tokens.map { |token| "#{type} #{token}" }
    end

    non_uniq = combinations.group_by { |str| str }.select { |_, v| v.count > 1 }

    assert_empty non_uniq.keys
  end
end
