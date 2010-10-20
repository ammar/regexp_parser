require "test/unit"
require File.expand_path("../../lib/regexp_parser", __FILE__)
require File.expand_path("../../lib/regexp_parser/lexer", __FILE__)

RP = Regexp::Parser
RL = Regexp::Lexer

include RP::Expression
