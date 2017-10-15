module Regexp::Expression

  module Backreference
    class Base < Regexp::Expression::Base; end

    class Name < Backreference::Base
      attr_reader :name

      def initialize(token, options = {})
        @name = token.text[3..-2]
        super
      end
    end

    class Number < Backreference::Base
      attr_reader :number

      def initialize(token, options = {})
        @number = token.text[token.token.equal?(:number) ? 1..-1 : 3..-2]
        super
      end
    end

    class NumberRelative      < Backreference::Number; end

    class NameNestLevel       < Backreference::Base; end
    class NumberNestLevel     < Backreference::Base; end

    class NameCall < Backreference::Base
      attr_reader :name

      def initialize(token, options = {})
        @name = token.text[3..-2]
        super
      end
    end

    class NumberCall          < Backreference::Base; end
    class NumberCallRelative  < Backreference::Base; end
  end

end
