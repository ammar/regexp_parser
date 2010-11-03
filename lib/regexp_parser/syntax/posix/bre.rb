module Regexp::Syntax

  # POSIX Basic Regular Expressions
  module POSIX
    class BRE < Regexp::Syntax::Base
      include Regexp::Syntax::Token

      def initialize
        super

        implements :anchors, Anchor::Basic

        implements :meta, Meta::Basic

        implements :group, [
          :capture, :close,
        ]

        implements :quantifier, [
          :interval_bre
        ]
      end

      def normalize(type, token)
        case type
        when :escape
          normalize_escape(type, token)
        when :group
          normalize_group(type, token)
        else
          [type, token]
        end
      end

      def normalize_escape(type, token)
        case token
        when :group_open
          [:group, :capture]
        when :group_close
          [:group, :close]
        else
          [type, token]
        end
      end

      def normalize_group(type, token)
        case token
        when :capture, :close
          [:literal, :literal]
        else
          [type, token]
        end
      end

    end
  end

end
