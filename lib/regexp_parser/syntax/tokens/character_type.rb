module Regexp::Syntax
  module Token

    module CharacterType
      Basic     = []
      Extended  = [:digit, :nondigit, :space, :nonspace, :word, :nonword]
      Hex       = [:hex, :nonhex]

      All = Basic + Extended + Hex
      Type = :type
    end

    Map[CharacterType::Type] = CharacterType::All

  end
end
