module Regexp::Syntax

  # POSIX Basic Regular Expressions
  # TODO: fill out this stub
  module POSIX
    class BRE < Regexp::Syntax::Base
      def initialize
        super

        implements :anchors, [
          :beginning_of_line,
          :end_of_line
        ]

        implements :type, [
          :any,
        ]

        implements :group, [
          :capture,
          :close,
        ]
      end
    end
  end

end
