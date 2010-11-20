require "test/unit"
require File.expand_path("../../lib/regexp_parser", __FILE__)

RS = Regexp::Scanner
RL = Regexp::Lexer
RP = Regexp::Parser

include Regexp::Expression
