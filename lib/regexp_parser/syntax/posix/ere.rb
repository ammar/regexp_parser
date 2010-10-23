require File.expand_path '../bre', __FILE__

module Regexp::Syntax

  # POSIX Extended Regular Expressions
  # TODO: fill out this stub
  module POSIX
    class ERE < Regexp::Syntax::POSIX::BRE
      def initialize
        super

        # add extensions
      end
    end
  end

end
