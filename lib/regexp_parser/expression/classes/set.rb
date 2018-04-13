module Regexp::Expression

  class CharacterSet < Regexp::Expression::Subexpression
    # alias for backwards compatibility
    alias :members :expressions

    def initialize(token, options = {})
      @negative = false
      @closed   = false
      super
    end

    # TODO: check if this is still necessary
    def <<(member)
      if expressions.last.is_a?(CharacterSet) && !expressions.last.closed?
        expressions.last << member
      else
        expressions << member
      end
    end

    def include?(member, directly = false)
      @members.each do |m|
        if m.is_a?(CharacterSet) and not directly
          return true if m.include?(member)
        else
          return true if member == m.to_s
        end
      end; false
    end

    def negate
      if @members.last.is_a?(CharacterSet)
        @members.last.negate
      else
        @negative = true
      end
    end

    def negative?
      @negative
    end
    alias :negated? :negative?

    def close
      if @members.last.is_a?(CharacterSet) and not @members.last.closed?
        @members.last.close
      else
        @closed = true
      end
    end

    def closed?
      @closed
    end

    # Returns an array of the members with any shorthand members like \d and \W
    # expanded to either traditional form or unicode properties.
    def expand_members(use_properties = false)
      @members.map do |member|
        case member
        when "\\d"
          use_properties ? '\p{Digit}'  : '0-9'
        when "\\D"
          use_properties ? '\P{Digit}'  : '^0-9'
        when "\\w"
          use_properties ? '\p{Word}'   : 'A-Za-z0-9_'
        when "\\W"
          use_properties ? '\P{Word}'   : '^A-Za-z0-9_'
        when "\\s"
          use_properties ? '\p{Space}'  : ' \t\f\v\n\r'
        when "\\S"
          use_properties ? '\P{Space}'  : '^ \t\f\v\n\r'
        when "\\h"
          use_properties ? '\p{Xdigit}' : '0-9A-Fa-f'
        when "\\H"
          use_properties ? '\P{Xdigit}' : '^0-9A-Fa-f'
        else
          member
        end
      end
    end

    def to_s(format = :full)
      s = ''

      s << @text.dup
      s << '^' if negative?
      s << @members.join
      s << ']'

      unless format == :base
        s << @quantifier.to_s if quantified?
      end

      s
    end
  end
end # module Regexp::Expression
