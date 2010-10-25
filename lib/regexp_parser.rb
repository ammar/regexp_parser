class Regexp

  module Parser
    VERSION = '0.0.1'
  end

  TOKEN_KEYS = [:type, :token, :text, :ts, :te, :depth].freeze
  Token = Struct.new(*TOKEN_KEYS) do
    def offset
      [self.ts, self.te]
    end

    def to_h
      hash = {}
      members.each do |member|
        hash[member.to_sym] = self.send(member.to_sym)
      end; hash
    end
  end

end

%w{scanner syntax lexer parser}.each do |file|
  require File.expand_path("../regexp_parser/#{file}", __FILE__)
end
