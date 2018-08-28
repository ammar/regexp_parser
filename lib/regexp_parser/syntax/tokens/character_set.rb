module Regexp::Syntax
  module Token

    module CharacterSet
      OpenClose = [:open, :close]

      Basic     = [:negate, :range]
      Extended  = Basic + [:intersection, :backspace]

      All = Basic + Extended
      Type = :set
    end

    Map[CharacterSet::Type] = CharacterSet::All
  end
end
