class Regexp

  TOKEN_KEYS = [:type, :id, :text, :ts, :te].freeze
  Token = Struct.new(*TOKEN_KEYS)

  module Parser
    VERSION = '0.0.1'
  end

end

require File.expand_path('../regexp_parser/lexer', __FILE__)
require File.expand_path('../regexp_parser/parser', __FILE__)
