module Regexp::Expression

  module Backreference
    class Base < Regexp::Expression::Base; end

    class Name < Backreference::Base
      attr_reader :name

      def initialize(token)
        @name = token.text[3..-2]
        super(token)
      end
    end

    class Number < Backreference::Base
      attr_reader :number

      def initialize(token)
        @number = token.text[3..-2]
        super(token)
      end
    end

    class NumberRelative      < Backreference::Number; end

    class NameNestLevel       < Backreference::Base; end
    class NumberNestLevel     < Backreference::Base; end

    class NameCall < Backreference::Base
      attr_reader :name

      def initialize(token)
        @name = token.text[3..-2]
        super(token)
      end
    end

    class NumberCall          < Backreference::Base; end
    class NumberCallRelative  < Backreference::Base; end
  end

end
