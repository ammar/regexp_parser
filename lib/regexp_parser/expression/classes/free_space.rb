module Regexp::Expression
  class FreeSpace < Regexp::Expression::Base
    def quantify(*_args)
      raise Regexp::Parser::Error, 'Can not quantify a free space object'
    end
  end

  class Comment < Regexp::Expression::FreeSpace
    def comment?
      true
    end
  end

  class WhiteSpace < Regexp::Expression::FreeSpace
    def merge(exp)
      text << exp.text
    end
  end
end
