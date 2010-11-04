module Regexp::Syntax

  module Token
    module Meta
      Basic     = [:dot]
      Extended  = Basic + [:alternation]
    end

    module Anchor
      Basic     = [:beginning_of_line, :end_of_line]
      Extended  = Basic + [:word_boundary, :nonword_boundary]
      String    = [:bos, :eos, :eos_ob_eol]
    end

    module Group
      Basic     = [:capture, :close]
      Extended  = Basic + [:options]
      Assertion = [:lookahead, :nlookahead, :lookbehind, :nlookbehind]
    end

    module CharacterType
      Basic     = []
      Extended  = [:digit, :nondigit, :hex, :nonhex, :space, :nonspace,
                   :word, :nonword]
    end

    module CharacterSet
      Basic     = [:open, :close, :negate, :member, :range]
      Extended  = Basic + [:escape, :intersection, :range_hex, :backspace]

      Types     = [:type_digit, :type_nondigit, :type_hex, :type_nonhex,
                   :type_space, :type_nonspace, :type_word, :type_nonword]

      module POSIX
        Standard  = [:class_alnum, :class_alpha, :class_blank, :class_cntrl,
                     :class_digit, :class_graph, :class_lower, :class_print,
                     :class_punct, :class_space, :class_upper, :class_xdigit]

        Extensions = [:class_ascii, :class_word]
        All    = Standard + Extensions
      end
    end

    module Quantifier
      Greedy      = [:zero_or_one, :zero_or_more, :one_or_more]
      Reluctant   = [:zero_or_one_reluctant, :zero_or_more_reluctant, :one_or_more_reluctant]
      Possessive  = [:zero_or_one_possessive, :zero_or_more_possessive, :one_or_more_possessive]
      Interval    = [:interval]
    end

    module Escape
      Basic     = [:backslash, :literal]

      Backreference = [:digit]

      ASCII = [:bell, :backspace, :escape, :form_feed, :newline, :carriage,
               :space, :tab, :vertical_tab]

      Meta  = [:dot, :alternation, :zero_or_one, :zero_or_more, :one_or_more,
               :beginning_of_line, :end_of_line, :group_open, :group_close,
               :interval_open, :interval_close, :set_open, :set_close, :baclslash]
    end
  end

end
