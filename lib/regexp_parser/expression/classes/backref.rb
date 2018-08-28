module Regexp::Expression
  module Backreference
    class Base < Regexp::Expression::Base; end

    class Number < Backreference::Base
      attr_reader :number

      def initialize(token, options = {})
        @number = token.text[token.token.equal?(:number) ? 1..-1 : 3..-2].to_i
        super
      end
    end

    class Name < Backreference::Base
      attr_reader :name

      def initialize(token, options = {})
        @name = token.text[3..-2]
        super
      end
    end

    class NumberCall         < Backreference::Number; end
    class NumberRelative     < Backreference::Number; end
    class NumberCallRelative < Backreference::Number; end
    class NameCall < Backreference::Name; end

    class NumberNestLevel < Backreference::Base
      attr_reader :number, :nest_level

      def initialize(token, options = {})
        @number, @nest_level = token.text[3..-2].split(/(?=[+-])/).map(&:to_i)
        super
      end
    end

    class NameNestLevel < Backreference::Base
      attr_reader :name, :nest_level

      def initialize(token, options = {})
        @name, nest_level = token.text[3..-2].split(/(?=[+-])/)
        @nest_level = nest_level.to_i
        super
      end
    end
  end
end
