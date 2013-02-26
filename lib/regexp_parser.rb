require 'yaml'

class Regexp
  module Parser
    VERFILE = File.expand_path('../../VERSION.yml', __FILE__)
    VERSION = YAML.load(File.read(VERFILE)).values.compact.join('.')
  end
end

%w{token ctype scanner syntax lexer parser}.each do |file|
  require File.expand_path("../regexp_parser/#{file}", __FILE__)
end
