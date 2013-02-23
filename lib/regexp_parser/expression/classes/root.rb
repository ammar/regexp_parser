module Regexp::Expression

  class Root < Regexp::Expression::Subexpression
    def initialize
      super Regexp::Token.new(:expression, :root, '', 0)
    end

    def multiline?
      @expressions[0].m?
    end
    alias :m? :multiline?

    def case_insensitive?
      @expressions[0].i?
    end
    alias :i? :case_insensitive?
    alias :ignore_case? :case_insensitive?

    def free_spacing?
      @expressions[0].x?
    end
    alias :x? :free_spacing?
    alias :extended? :free_spacing?
  end

end
