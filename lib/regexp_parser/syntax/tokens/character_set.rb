module Regexp::Syntax
  module Token

    module CharacterSet
      OpenClose = [:open, :close]

      Basic     = [:negate, :member, :range]
      Extended  = Basic + [:escape, :intersection, :range_hex, :backspace]

      Types     = [:type_digit, :type_nondigit, :type_hex, :type_nonhex,
                   :type_space, :type_nonspace, :type_word, :type_nonword]

      module POSIX
        Standard  = [
          :class_alnum, :class_alpha, :class_blank, :class_cntrl,
          :class_digit, :class_graph, :class_lower, :class_print,
          :class_punct, :class_space, :class_upper, :class_xdigit,
        ]

        StandardNegative = [
          :class_nonalnum, :class_nonalpha, :class_nonblank,
          :class_noncntrl, :class_nondigit, :class_nongraph,
          :class_nonlower, :class_nonprint, :class_nonpunct,
          :class_nonspace, :class_nonupper, :class_nonxdigit,
        ]

        Extensions         = [:class_ascii, :class_word]
        ExtensionsNegative = [:class_nonascii, :class_nonword]

        All = Standard + StandardNegative + Extensions + ExtensionsNegative
      end

      All = Basic + Extended + Types + POSIX::All
      Type = :set

      module SubSet
        OpenClose = [:open, :close]

        All = CharacterSet::All
        Type = :subset
      end
    end

    Map[CharacterSet::Type] = CharacterSet::All
    Map[CharacterSet::SubSet::Type] = CharacterSet::All

  end
end
