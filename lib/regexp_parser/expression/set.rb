module Regexp::Expression

  class CharacterSet < Regexp::Expression::Base
    attr_accessor :members

    def initialize(token)
      @members = []
      @negative = false
      super
    end

    def <<(member)
      if @members.last.is_a?(CharacterSubSet)
        @members.last << member
      else
        @members << member
      end
    end

    def include?(member)
      @members.each do |m|
        if m.is_a?(CharacterSubSet)
          return true if m.include?(member)
        else
          return true if member == m.to_s
        end
      end; false
    end

    def negate
      if @members.last.is_a?(CharacterSubSet)
        @members.last.negate
      else
        @negative = true
      end
    end

    def negative?
      @negative
    end
    alias :negated? :negative?

    def to_s
      s = @text.dup
      s << '^' if negative?
      s << @members.join
      s << ']'
      s << @quantifier.to_s if quantified?
      s
    end

    def matches?(input)
      input =~ /#{to_s}/ ? true : false
    end
  end

  class CharacterSubSet < CharacterSet; end

end # module Regexp::Expression
