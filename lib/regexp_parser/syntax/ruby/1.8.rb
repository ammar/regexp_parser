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
          Escape::Basic + Escape::Backreference +
          Escape::ASCII + Escape::Meta

        implements :group, Group::All

        implements :assertion, Group::Assertion::All

        implements :set, 
          CharacterSet::Extended + CharacterSet::Types +
          CharacterSet::POSIX::Standard 

        implements :type,
          CharacterType::Extended

        implements :quantifier, 
          Quantifier::Greedy + Quantifier::Interval
      end
    end
  end

end
