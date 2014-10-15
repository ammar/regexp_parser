require 'yaml'

class Regexp
  module Parser
    VERFILE = File.expand_path('../../VERSION.yml', __FILE__)
    VERSION = YAML.load(File.read(VERFILE)).values.compact.join('.')
  end
end

require 'regexp_parser/ctype'
require 'regexp_parser/token'
require 'regexp_parser/scanner'
require 'regexp_parser/syntax'
require 'regexp_parser/lexer'
require 'regexp_parser/parser'
