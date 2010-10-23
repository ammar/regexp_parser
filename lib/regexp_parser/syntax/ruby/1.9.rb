require File.expand_path '../1.8', __FILE__

module Regexp::Syntax

  # POSIX Extended Regular Expressions
  # TODO: fill out this stub
  module Ruby
    class V19 < Regexp::Syntax::Ruby::V18
      def initialize
        super

        # add extensions
        implements :quantifier, [
          :zero_or_one_reluctant,
          :zero_or_more_reluctant,
          :one_or_more_reluctant,
        ]
      end
    end
  end

end
