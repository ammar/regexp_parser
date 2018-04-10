module Regexp::Syntax
  class V2_4_1 < Regexp::Syntax::V2_4_0
    def initialize
      super

      implements :group, Group::Absence
    end
  end
end
