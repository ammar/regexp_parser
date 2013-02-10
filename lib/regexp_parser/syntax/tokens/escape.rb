module Regexp::Syntax
  module Token

    module Escape
      Basic     = [:backslash, :literal]

      Backreference = [:digit]

      Control = [:control, :meta_sequence]

      ASCII = [:bell, :backspace, :escape, :form_feed, :newline, :carriage,
               :space, :tab, :vertical_tab]

      Meta  = [:dot, :alternation, :zero_or_one, :zero_or_more, :one_or_more,
               :beginning_of_line, :end_of_line, :group_open, :group_close,
               :interval_open, :interval_close, :set_open, :set_close, :baclslash]

      All   = Basic + Backreference + ASCII + Meta
      Type  = :escape
    end

    Map[Escape::Type] = Escape::All

  end
end
