module Regexp::Syntax
  module Token

    module Group
      Basic     = [:capture, :close]
      Extended  = Basic + [:options]

      Named     = [:named]
      Atomic    = [:atomic]
      Passive   = [:passive]
      Comment   = [:comment]

      All = Group::Extended + Group::Named + Group::Atomic +
            Group::Passive + Group::Comment

      Absence = [:absence]

      Type = :group
    end

    Map[Group::Type] = Group::All

  end
end
