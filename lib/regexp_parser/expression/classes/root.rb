module Regexp::Expression

  class Root < Regexp::Expression::Subexpression
    def initialize(options = {})
      super(Regexp::Token.new(:expression, :root, '', 0), options)
    end

    alias ignore_case? case_insensitive?
    alias extended?    free_spacing?
  end

end
