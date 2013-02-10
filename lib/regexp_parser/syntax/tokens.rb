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

%w{
 anchor assertion backref character_set character_type
 escape group meta quantifier unicode_property
}.each do |file|
  require File.expand_path("../tokens/#{file}", __FILE__)
end

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
