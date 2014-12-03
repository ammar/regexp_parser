module Regexp::Expression

  class CharacterSet < Regexp::Expression::Base
    attr_accessor :members

    def initialize(token)
      @members  = []
      @negative = false
      @closed   = false
      super
    end

    # Override base method to clone set members as well.
    def clone
      copy = super
      copy.members = @members.map {|m| m.clone }
      copy
    end

    def <<(member)
      if @members.last.is_a?(CharacterSubSet) and not @members.last.closed?
        @members.last << member
      else
        @members << member
      end
    end

    def include?(member, directly = false)
      @members.each do |m|
        if m.is_a?(CharacterSubSet) and not directly
          return true if m.include?(member)
        else
          return true if member == m.to_s
        end
      end; false
    end

    def each(&block)
      @members.each {|m| yield m}
    end

    def each_with_index(&block)
      @members.each_with_index {|m, i| yield m, i}
    end

    def length
      @members.length
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

    def close
      if @members.last.is_a?(CharacterSubSet) and not @members.last.closed?
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

  class CharacterSubSet < CharacterSet
  end

end # module Regexp::Expression
