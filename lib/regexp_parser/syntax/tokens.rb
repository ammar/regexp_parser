# Define the base module and the simplest of tokens.
module Regexp::Syntax
  module Token
    Map = {}

    module Literal
      All = [:literal]
      Type = :literal
    end

    Map[Literal::Type] = Literal::All
  end
end


# Load all the token files, they will populate the Map constant.
Dir[File.dirname(__FILE__) + '/tokens/*.rb'].each {|f| require f }


# After loading all the tokens the map is full. Extract all tokens and types
# into the All and Types constants.
module Regexp::Syntax
  module Token
    if RUBY_VERSION >= '1.9'
      All = Map.map {|k,v| v}.flatten.uniq.sort
    else
      All = Map.map {|k,v| v}.flatten.uniq
    end

    Types = Map.keys

    All.freeze
    Types.freeze
  end
end
