module Regexp::Expression

  class CharacterSet < Regexp::Expression::Base
    attr_accessor :members

    def initialize(token)
      @members = []
      @negative = false
      super
    end

    def <<(member)
      if member.length == 1
        @members << member
      elsif member =~ /\\./
        @members << member
      elsif member =~ /\[:(\w+):\]/
        case $1
        when 'alnum';   CType::Alnum.each  {|c| @members << c }
        when 'alpha';   CType::Alpha.each  {|c| @members << c }
        when 'blank';   CType::Blank.each  {|c| @members << c }
        when 'cntrl';   CType::Cntrl.each  {|c| @members << c }
        when 'digit';   CType::Digit.each  {|c| @members << c }
        when 'graph';   CType::Graph.each  {|c| @members << c }
        when 'lower';   CType::Lower.each  {|c| @members << c }
        when 'print';   CType::Print.each  {|c| @members << c }
        when 'punct';   CType::Punct.each  {|c| @members << c }
        when 'space';   CType::Space.each  {|c| @members << c }
        when 'upper';   CType::Upper.each  {|c| @members << c }
        when 'xdigit';  CType::XDigit.each {|c| @members << c }
        when 'word';    CType::Word.each   {|c| @members << c }
        when 'ascii';   CType::ASCII.each  {|c| @members << c }
        else
          raise "Unexpected posix class name '#{$1}' character set member"
        end
      elsif member =~ /\[.([\w-]+).\]/
        # TODO: add collation sequences
      elsif member =~ /\[=(\w+)=\]/
        # TODO: add character equivalents
      else
        raise "Unexpected character set member '#{member}'"
      end

      @members.uniq!
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
  end

end # module Regexp::Expression
