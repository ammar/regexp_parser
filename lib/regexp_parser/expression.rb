module Regexp::Expression
  class Base
    attr_reader :type, :token, :text
    attr_reader :quantifier
    attr_reader :expressions

    attr_accessor :options

    def initialize(token)
      @type         = token.type
      @token        = token.token
      @text         = token.text
      @options      = nil
      @expressions  = []
    end

    def to_s
      s = @text.dup
      s << @expressions.map{|e| e.to_s}.join unless @expressions.empty?
      s << @quantifier if quantified?
      s
    end

    def <<(exp)
      @expressions << exp
    end

    def each(&block)
      @expressions.each {|e| yield e}
    end

    def [](index)
      @expressions[index]
    end

    def quantify(token, text, min = nil, max = nil, mode = :greedy)
      @quantifier = Quantifier.new(token, text, min, max, mode)
    end

    def quantified?
      not @quantifier.nil?
    end

    def quantity
      [@quantifier.min, @quantifier.max]
    end

    def greedy?
      @quantifier.mode == :greedy
    end

    def reluctant?
      @quantifier.mode == :reluctant
    end
    alias :lazy? :reluctant?

    def possessive?
      @quantifier.mode == :possessive
    end

    def multiline?
      (@options and @options[:m]) ? true : false
    end
    alias :m? :multiline?

    def case_insensitive?
      (@options and @options[:i]) ? true : false
    end
    alias :i? :case_insensitive?
    alias :ignore_case? :case_insensitive?

    def free_spacing?
      (@options and @options[:x]) ? true : false
    end
    alias :x? :free_spacing?
    alias :extended? :free_spacing?
  end

  class Root < Regexp::Expression::Base
    def initialize
      super Regexp::Token.new(:expression, :root, '')
    end

    def multiline?
      @expressions[0].m?
    end
    alias :m? :multiline?

    def case_insensitive?
      @expressions[0].i?
    end
    alias :i? :case_insensitive?

    def free_spacing?
      @expressions[0].x?
    end
    alias :x? :free_spacing?
  end

  class Quantifier
    attr_reader :token, :text, :min, :max, :mode

    def initialize(token, text, min, max, mode)
      @token = token
      @text  = text
      @mode  = mode
      @min   = min
      @max   = max
    end

    def to_s
      @text.dup
    end
    alias :to_str :to_s
  end

  class Literal < Regexp::Expression::Base; end

  module Backreference
    class Base < Regexp::Expression::Base; end

    class Name                < Backreference::Base; end
    class Number              < Backreference::Base; end
    class NumberRelative      < Backreference::Base; end

    class NameNestLevel       < Backreference::Base; end
    class NumberNestLevel     < Backreference::Base; end

    class NameCall            < Backreference::Base; end
    class NumberCall          < Backreference::Base; end
    class NumberCallRelative  < Backreference::Base; end
  end

  module Anchor
    class Base < Regexp::Expression::Base; end

    class BeginningOfLine               < Anchor::Base; end
    class EndOfLine                     < Anchor::Base; end

    class BeginningOfString             < Anchor::Base; end
    class EndOfString                   < Anchor::Base; end

    class EndOfStringOrBeforeEndOfLine  < Anchor::Base; end

    class WordBoundary                  < Anchor::Base; end
    class NonWordBoundary               < Anchor::Base; end

    class MatchStart                    < Anchor::Base; end

    BOL      = BeginningOfLine 
    EOL      = EndOfLine 
    BOS      = BeginningOfString
    EOS      = EndOfString
    EOSobEOL = EndOfStringOrBeforeEndOfLine
  end

  module CharacterType
    class Base < Regexp::Expression::Base; end

    class Any         < CharacterType::Base; end
    class Digit       < CharacterType::Base; end
    class NonDigit    < CharacterType::Base; end
    class Hex         < CharacterType::Base; end
    class NonHex      < CharacterType::Base; end
    class Word        < CharacterType::Base; end
    class NonWord     < CharacterType::Base; end
    class Space       < CharacterType::Base; end
    class NonSpace    < CharacterType::Base; end
  end

  module EscapeSequence
    class Base          < Regexp::Expression::Base; end

    class Literal       < EscapeSequence::Base; end

    class AsciiEscape   < EscapeSequence::Base; end
    class Backspace     < EscapeSequence::Base; end
    class Bell          < EscapeSequence::Base; end
    class FormFeed      < EscapeSequence::Base; end
    class Newline       < EscapeSequence::Base; end
    class Return        < EscapeSequence::Base; end
    class Space         < EscapeSequence::Base; end
    class Tab           < EscapeSequence::Base; end
    class VerticalTab   < EscapeSequence::Base; end

    class Octal         < EscapeSequence::Base; end
    class Hex           < EscapeSequence::Base; end
    class HexWide       < EscapeSequence::Base; end

    class Control       < EscapeSequence::Base; end
    class Meta          < EscapeSequence::Base; end
    class MetaControl   < EscapeSequence::Base; end
  end

  class Alternation < Regexp::Expression::Base
    def <<(exp)
      @expressions.last << exp
    end

    def alternative(exp = nil)
      @expressions << (exp ? exp : Sequence.new)
    end

    def alternatives
      @expressions
    end

    def quantify(token, text, min = nil, max = nil, mode = :greedy)
      @expressions.last.last.quantify(token, text, min, max, mode)
    end

    def to_s
      @expressions.map{|e| e.to_s}.join('|')
    end
  end

  # a sequence of expressions, used by alternations
  class Sequence < Regexp::Expression::Base
    def initialize
      super Regexp::Token.new(:expression, :sequence, '')
    end

    def <<(exp)
      @expressions << exp
    end

    def insert(exp)
      @expressions.insert 0, exp
    end

    def first
      @expressions.first
    end

    def last
      @expressions.last
    end

    def quantify(token, text, min = nil, max = nil, mode = :greedy)
      last.quantify(token, text, min, max, mode)
    end
  end

  module Group
    class Base < Regexp::Expression::Base
      def capturing?
        [:capture, :named].include? @token
      end

      def comment?; @type == :comment end

      def to_s
        s = @text.dup
        s << @expressions.join
        s << ')'
        s << @quantifier.to_s if quantified?
        s
      end
    end

    class Atomic    < Group::Base; end
    class Capture   < Group::Base; end
    class Named     < Group::Base; end
    class Passive   < Group::Base; end

    class Options   < Group::Base; end

    class Comment   < Group::Base
      def to_s; @text.dup end
    end
  end

  class Assertion
    class Base < Regexp::Expression::Group::Base; end

    class Lookahead           < Assertion::Base; end
    class NegativeLookahead   < Assertion::Base; end

    class Lookbehind          < Assertion::Base; end
    class NegativeLookbehind  < Assertion::Base; end
  end

end # module Regexp::Expression

%w{property set}.each do|file|
  require File.expand_path("../expression/#{file}", __FILE__)
end
