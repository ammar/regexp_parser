# frozen_string_literal: true

module Regexp::Expression
  module Group
    class Base < Regexp::Expression::Subexpression
    end

    class Passive < Group::Base
      attr_writer :implicit

      def initialize(*)
        @implicit = false
        super
      end

      def implicit?
        @implicit
      end
    end

    class Absence < Group::Base; end
    class Atomic  < Group::Base; end
    # TODO: should split off OptionsSwitch in v3.0.0. Maybe even make it no
    # longer inherit from Group because it is effectively a terminal expression.
    class Options < Group::Base
      attr_accessor :option_changes

      def quantify(*args)
        # in Ruby, /a(?i)+b/ raises SyntaxError, but /a(?i:)b/ is allowed
        if token == :options_switch
          raise Regexp::Parser::Error, 'Can not quantify an option switch'
        else
          super
        end
      end
    end

    class Capture < Group::Base
      attr_accessor :number, :number_at_level
      alias identifier number
    end

    class Named < Group::Capture
      def name
        text[3..-2]
      end
      alias identifier name
    end

    class Comment < Group::Base
    end
  end

  module Assertion
    class Base < Regexp::Expression::Group::Base; end

    class Lookahead           < Assertion::Base; end
    class NegativeLookahead   < Assertion::Base; end

    class Lookbehind          < Assertion::Base; end
    class NegativeLookbehind  < Assertion::Base; end
  end
end
