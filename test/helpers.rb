require "test/unit"
require File.expand_path("../../lib/regexp_parser", __FILE__)

RS = Regexp::Scanner
RL = Regexp::Lexer
RP = Regexp::Parser

include Regexp::Expression

def pr(re, d=0)
  if d == 0
    print "[#{d}]#{'  ' * d}#{re.class.name}"
    print " quantifier: #{re.quantifier.to_s}" if re.quantified?
    puts
  end

  re.expressions.each do |e|
    if e.expressions.empty?
      puts "[#{d+1}]#{'  ' * (d+1)}#{e.class.name} : #{e.text}"
    else
      puts "[#{d+1}]#{'  ' * (d+1)}#{e.class.name}: #{e.text}"
      pr(e, d+1)
    end
  end
end

def pt(tokens)
  tokens.each_with_index do |token, i|
    puts "#{'%02d' % i}: #{token.inspect}"
  end
end
