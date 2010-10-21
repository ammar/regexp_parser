require File.expand_path("../../helpers", __FILE__)

class LexerGroups < Test::Unit::TestCase

  tests = {
   '(?-mix)'       => [:group,     :options,     '(?-mix'],

   '(?>abc)'       => [:group,     :atomic,      '(?>'],
   '(abc)'         => [:group,     :capture,     '('],
   '(?<name>abc)'  => [:group,     :named,       '(?<name>'],
   '(?:abc)'       => [:group,     :passive,     '(?:'],

   '(?#abc)'       => [:group,     :comment,     '(?#abc)'],

   '(?=abc)'       => [:assertion, :lookahead,   '(?='],
   '(?!abc)'       => [:assertion, :nlookahead,  '(?!'],
   '(?<=abc)'      => [:assertion, :lookbehind,  '(?<='],
   '(?<!abc)'      => [:assertion, :nlookbehind, '(?<!'],
  }

  tests.each do |pattern, test|
    [:type, :token, :text].each_with_index do |member, i|
      define_method "test_lex_#{test[0]}_#{test[1]}_#{member}" do
        assert_equal( test[i], RL.lex(pattern)[0].send(member))
      end
    end
  end

end
