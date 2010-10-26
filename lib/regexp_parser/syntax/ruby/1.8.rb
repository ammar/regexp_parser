module Regexp::Syntax

  module Ruby
    class V18 < Regexp::Syntax::Base

      include Regexp::Syntax::Token

      def initialize
        super

        implements :meta, Meta::Extended

        implements :anchor,
          Anchor::Extended + Anchor::String

        implements :escape, 
          Escape::Backreference + Escape::ASCII +
          Escape::Meta

        implements :group, [
          :capture,
          :options,
          :close,
        ]

        implements :set, [
          :open, :close, :negate, :escape, :intersection, :member,
          :range, :range_hex, :backspace,

          :type_digit, :type_nondigit,
          :type_hex,   :type_nonhex,
          :type_space, :type_nonspace,
          :type_word,  :type_nonword
        ]

        implements :type, [
          :any,
          :digit, :nondigit,
          :hex,   :nonhex,
          :space, :nonspace,
          :word, :nonword,
        ]

        implements :quantifier, [
          :zero_or_one,
          :zero_or_more,
          :one_or_more,
          :interval,
        ]
      end
    end
  end

end
