module Regexp::Syntax
  module Token

    module Anchor
      Basic       = [:beginning_of_line, :end_of_line]
      Extended    = Basic + [:word_boundary, :nonword_boundary]
      String      = [:bos, :eos, :eos_ob_eol]
      MatchStart  = [:match_start]

      All = Extended + String + MatchStart
      Type = :anchor
    end

    Map[Anchor::Type] = Anchor::All

  end
end
