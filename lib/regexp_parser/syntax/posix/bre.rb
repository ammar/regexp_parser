module Regexp::Syntax

  # POSIX Basic Regular Expressions
  module POSIX
    class BRE < Regexp::Syntax::Base
      include Regexp::Syntax::Token

      def initialize
        super

        implements :anchor, Anchor::Basic
        implements :backref, [:digit]
        implements :escape, [:literal]
        implements :group, [:capture, :close]
        implements :set, CharacterSet::Basic
        implements :meta, Meta::Basic
        implements :quantifier, [
          :zero_or_more, :interval_bre
        ]
      end

      def normalize(type, token)
        case type
        when :escape
          normalize_escape(type, token)
        when :group
          normalize_group(type, token)
        when :quantifier
          normalize_quantifier(type, token)
        else
          [type, token]
        end
      end

      def normalize_escape(type, token)
        case token
        when *Escape::ASCII
          [:escape, :literal]
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

      def normalize_quantifier(type, token)
        case token
        when :zero_or_one, :one_or_more
          [:literal, :literal]
        else
          [type, token]
        end
      end

    end
  end

end
