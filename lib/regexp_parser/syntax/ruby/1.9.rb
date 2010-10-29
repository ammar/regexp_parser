require File.expand_path('../1.8', __FILE__)

module Regexp::Syntax

  module Ruby
    class V19 < Regexp::Syntax::Ruby::V18
      def initialize
        super

        implements :quantifier, [
          :zero_or_one_reluctant, :zero_or_more_reluctant, :one_or_more_reluctant,
          :zero_or_one_possessive, :zero_or_more_possessive, :one_or_more_possessive,
        ]

        implements :escape, [:backslash]

        implements :set, 
          CharacterSet::POSIX::Extensions 
      end
    end
  end

end
