require "test/unit"
require File.expand_path("../../lib/regexp_parser", __FILE__)

RS = Regexp::Scanner
RL = Regexp::Lexer
RP = Regexp::Parser

# move this one namescape higher, and just include Regexp?
include RP::Expression

def pr(re, d=0)
  puts "[#{d}]#{'  ' * d}#{re.class.name}"
  re.expressions.each do |e|
    if e.expressions.empty?
      puts "[#{d+1}]#{'  ' * (d+1)}#{e.class.name} : #{e.text}"
    else
      puts "[#{d+1}]#{'  ' * (d+1)}#{e.class.name}"
      pr(e, d+2)
    end
  end
end
