module Regexp::Parser

  class Node
    class Base
      attr_reader :start, :end, :text
      attr_reader :quantifier, :min, :max

      def initialize(text, ts, te)
        @text   = text[ts..te-1].pack("c*")
        @start  = ts
        @end    = te
      end

      def quantify(quantifier, min = nil, max = nil)
        @quantifier = quantifier
        @min        = min
        @max        = max
      end

      def quantified?
        not @quantifier.nil?
      end
    end

    class Literal < Node::Base
      def type; :literal end
    end

    class Anchor < Node::Base
      def type; :anchor end
    end

    class CharacterSet < Node::Base
      def type; :character_set end
    end

    class CharacterType < Node::Base
      def type; :character_type end
    end


    class Group < Node::Base
      def type; :group end

      def initialize(*args)
        @children=[]
        super
      end

      def << node; @children<<node end
      # We might need to parse sub-groups by hand in here. See the last
      # section on the last page of the ragel guide:
      #
      # http://www.complang.org/ragel/ragel-guide-6.6.pdf
    end

  end # class Node
end # class Regexp
