module Regexp::Syntax
  module Token

    module CharacterSet
      OpenClose = [:open, :close]

      Basic     = [:negate, :range]
      Extended  = Basic + [:intersection, :backspace]

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

      All = Basic + Extended + POSIX::All
      Type = :set
    end

    Map[CharacterSet::Type] = CharacterSet::All

  end
end
