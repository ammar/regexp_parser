require File.expand_path("../../helpers", __FILE__)

class LexerEscapes < Test::Unit::TestCase

  tests = {
    'c\at'          => [:escape,  :literal,   '\a',       1],

    'a\x24c'        => [:escape,  :hex,       '\x24',     1],
    #'a\x{0640}c'   => [:escape,  :hex,       '\x{0640}', 1],

    #'a\c2c'        => [:escape,  :hex,       '\c2',     1],
  }

  literal_count = 0

  tests.each do |pattern, test|
    case test[1]
    when :literal; name = "literal_#{literal_count += 1}"
    else name = test[1]
    end

    [:type, :token, :text].each_with_index do |member, i|
      define_method "test_lex_#{test[0]}_#{name}_#{member}" do
        t = RL.scan(pattern)[test[3]]
        assert_equal( test[i], t.send(member))
      end
    end
  end

end
