require "test/unit"
require File.expand_path("../../lib/regexp_parser", __FILE__)

RP = Regexp::Parser
RL = Regexp::Lexer

include RP::Expression
