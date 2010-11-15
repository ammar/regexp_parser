module Regexp::Expression

  class CharacterSet < Regexp::Expression::Base
    attr_accessor :members

    def initialize(token)
      @members = []
      @negative = false
      super
    end

    def <<(member)
      @members << member
    end

    def include?(member)
      @members.include? member
    end

    def negate
      @negative = true
    end

    def negative?
      @negative
    end
    alias :negated? :negative?

    def to_s
      s = @text
      s << '^' if negative?
      s << @members.join
      s << ']'
      s << @quantifier.to_s if quantified?
      s
    end

    def matches?(s)
      @members.each do |m|
        return true if s =~ /[#{m}]/
      end; false
    end
  end

end # module Regexp::Expression
