class Regexp
  module Parser
    VERSION = '0.0.1'
  end
end

%w{token ctype scanner syntax lexer parser}.each do |file|
  require File.expand_path("../regexp_parser/#{file}", __FILE__)
end
