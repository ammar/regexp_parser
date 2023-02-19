module Regexp::Expression
  module Backref
    class Base < Regexp::Expression::Base
      attr_accessor :referenced_expression

      def initialize_copy(orig)
        exp_id = [self.class, self.starts_at]

        # prevent infinite recursion for recursive subexp calls
        copied = @@copied ||= {}
        self.referenced_expression =
          if copied[exp_id]
            orig.referenced_expression
          else
            copied[exp_id] = true
            orig.referenced_expression.dup
          end
        copied.clear

        super
      end
    end

    class Number < Backref::Base
      attr_reader :number
      alias reference number

      def initialize(token, options = {})
        @number = token.text[token.token.equal?(:number) ? 1..-1 : 3..-2].to_i
        super
      end
    end

    class Name < Backref::Base
      attr_reader :name
      alias reference name

      def initialize(token, options = {})
        @name = token.text[3..-2]
        super
      end
    end

    class NumberRelative     < Backref::Number
      attr_accessor :effective_number
      alias reference effective_number
    end

    class NumberCall         < Backref::Number; end
    class NameCall           < Backref::Name; end
    class NumberCallRelative < Backref::NumberRelative; end

    class NumberRecursionLevel < Backref::NumberRelative
      attr_reader :recursion_level

      def initialize(token, options = {})
        super
        @number, @recursion_level = token.text[3..-2].split(/(?=[+-])/).map(&:to_i)
      end
    end

    class NameRecursionLevel < Backref::Name
      attr_reader :recursion_level

      def initialize(token, options = {})
        super
        @name, recursion_level = token.text[3..-2].split(/(?=[+-])/)
        @recursion_level = recursion_level.to_i
      end
    end
  end
end
