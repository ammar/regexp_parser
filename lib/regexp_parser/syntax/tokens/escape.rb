module Regexp::Syntax
  module Token

    module Escape
      Basic     = [:backslash, :literal]

      Backreference = [:digit]

      Control = [:control, :meta_sequence]

      ASCII = [:bell, :backspace, :escape, :form_feed, :newline, :carriage,
               :space, :tab, :vertical_tab]

      Unicode = [:codepoint, :codepoint_list]

      Meta  = [:dot, :alternation,
               :zero_or_one, :zero_or_more, :one_or_more,
               :bol, :eol,
               :group_open, :group_close,
               :interval_open, :interval_close,
               :set_open, :set_close,
               :baclslash]

      Hex   = [:hex]

      All   = Basic + Backreference + ASCII + Meta
      Type  = :escape
    end

    Map[Escape::Type] = Escape::All

  end
end
