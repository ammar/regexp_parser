require "test/unit"
require File.expand_path("../../lib/regexp_parser", __FILE__)
require 'regexp_property_values'

RS = Regexp::Scanner
RL = Regexp::Lexer
RP = Regexp::Parser
RE = Regexp::Expression

include Regexp::Expression
