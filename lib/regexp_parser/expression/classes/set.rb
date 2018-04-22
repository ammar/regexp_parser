module Regexp::Expression

  class CharacterSet < Regexp::Expression::Subexpression
    attr_accessor :closed, :negative

    alias :negative? :negative
    alias :negated?  :negative
    alias :closed?   :closed

    def initialize(token, options = {})
      self.negative = false
      self.closed   = false
      super
    end

    def negate
      self.negative = true
    end

    def close
      self.closed = true
    end

    def to_s(format = :full)
      "#{text}#{'^' if negated?}#{expressions.join}]#{quantifier_affix(format)}"
    end

    # TODO: these made more sense with string members. remove/replace in v1.0.0?
    module LegacyCompatibilityMethods
      def members
        expressions.map { |exp| exp.is_a?(CharacterSet) ? exp : exp.to_s }
      end

      # Returns an array of the members with any shorthand members like \d and \W
      # expanded to either traditional form or unicode properties.
      def expand_members(use_properties = false)
        members.map do |member|
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

      def include?(member, directly = false)
        members.any? do |m|
          if m.is_a?(CharacterSet)
            !directly && m.include?(member)
          else
            m == member
          end
        end
      end
    end
    include LegacyCompatibilityMethods
  end
end # module Regexp::Expression
