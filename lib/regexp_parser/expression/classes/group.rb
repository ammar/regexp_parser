module Regexp::Expression

  module Group
    class Base < Regexp::Expression::Subexpression
      def capturing?
        [:capture, :named].include? @token
      end

      def comment?; @type == :comment end

      def to_s(format = :full)
        s = ''

        case format
        when :base
          s << @text.dup
          s << @expressions.join
          s << ')'
        else
          s << @text.dup
          s << @expressions.join
          s << ')'
          s << @quantifier.to_s if quantified?
        end

        s
      end
    end

    class Atomic    < Group::Base; end
    class Capture   < Group::Base; end
    class Passive   < Group::Base; end
    class Options   < Group::Base; end
    class Absence   < Group::Base; end

    class Named     < Group::Capture
      attr_reader :name

      def initialize(token)
        @name = token.text[3..-2]
        super(token)
      end

      def clone
        copy = super
        copy.instance_variable_set(:@name, @name.dup)
        copy
      end
    end

    class Comment   < Group::Base
      def to_s(format = :full)
        @text.dup
      end
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
