require File.expand_path("../../../helpers", __FILE__)

class TestSyntaxRuby_V18 < Test::Unit::TestCase

  def setup
    @syntax = Regexp::Syntax.new 'ruby/1.8'
  end

  tests = {
    :implements => {
      :escape => [:backspace].flatten,
    },

    :excludes => {
    },
  }

  tests.each do |method, types|
    types.each do |type, tokens|
      tokens.each do |token|
        define_method "test_syntax_v18_#{method}_#{type}_#{token}" do
          assert_equal(
            method == :excludes ? false : true,
            @syntax.implements?(type, token)
          )
        end
      end
    end
  end

end
