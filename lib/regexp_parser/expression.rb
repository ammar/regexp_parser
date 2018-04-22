module Regexp::Expression

  class Base
    attr_accessor :type, :token
    attr_accessor :text, :ts
    attr_accessor :level, :set_level, :conditional_level

    attr_accessor :quantifier
    attr_accessor :options

    def initialize(token, options = {})
      self.type              = token.type
      self.token             = token.token
      self.text              = token.text
      self.ts                = token.ts
      self.level             = token.level
      self.set_level         = token.set_level
      self.conditional_level = token.conditional_level
      self.quantifier        = nil
      self.options           = options
    end

    def clone
      copy = dup

      copy.text       = (text        ? text.dup         : nil)
      copy.options    = (options     ? options.dup      : nil)
      copy.quantifier = (quantifier  ? quantifier.clone : nil)

      copy
    end

    def to_re(format = :full)
      ::Regexp.new(to_s(format))
    end

    alias :starts_at :ts

    def full_length
      to_s.length
    end

    def offset
      [starts_at, full_length]
    end

    def coded_offset
      '@%d+%d' % offset
    end

    def to_s(format = :full)
      "#{text}#{quantifier_affix(format)}"
    end

    def quantifier_affix(expression_format)
      quantifier.to_s if quantified? && expression_format != :base
    end

    def terminal?
      !respond_to?(:expressions)
    end

    def quantify(token, text, min = nil, max = nil, mode = :greedy)
      self.quantifier = Quantifier.new(token, text, min, max, mode)
    end

    def quantified?
      !quantifier.nil?
    end

    def quantity
      return [nil,nil] unless quantified?
      [quantifier.min, quantifier.max]
    end

    def greedy?
      quantified? and quantifier.mode == :greedy
    end

    def reluctant?
      quantified? and quantifier.mode == :reluctant
    end
    alias :lazy? :reluctant?

    def possessive?
      quantified? and quantifier.mode == :possessive
    end

    def multiline?
      options[:m] == true
    end
    alias :m? :multiline?

    def case_insensitive?
      options[:i] == true
    end
    alias :i? :case_insensitive?
    alias :ignore_case? :case_insensitive?

    def free_spacing?
      options[:x] == true
    end
    alias :x? :free_spacing?
    alias :extended? :free_spacing?

    if RUBY_VERSION >= '2.0'
      def default_classes?
        options[:d] == true
      end
      alias :d? :default_classes?

      def ascii_classes?
        options[:a] == true
      end
      alias :a? :ascii_classes?

      def unicode_classes?
        options[:u] == true
      end
      alias :u? :unicode_classes?
    end

    def matches?(string)
      Regexp.new(to_s) =~ string ? true : false
    end

    def match(string, offset)
      Regexp.new(to_s).match(string, offset)
    end
    alias :=~ :match

    def to_h
      {
        type:              type,
        token:             token,
        text:              to_s(:base),
        starts_at:         ts,
        length:            full_length,
        level:             level,
        set_level:         set_level,
        conditional_level: conditional_level,
        options:           options,
        quantifier:        quantified? ? quantifier.to_h : nil,
      }
    end
  end

  def self.parsed(exp)
    case exp
    when String
      Regexp::Parser.parse(exp)
    when Regexp
      Regexp::Parser.parse(exp.source)
    when Regexp::Expression
      exp
    else
      raise ArgumentError, 'Expression.parsed accepts a String, Regexp, or '\
                           'a Regexp::Expression as a value for exp, but it '\
                           "was given #{exp.class.name}."
    end
  end

end # module Regexp::Expression

require 'regexp_parser/expression/methods/tests'
require 'regexp_parser/expression/methods/traverse'
require 'regexp_parser/expression/methods/strfregexp'

require 'regexp_parser/expression/quantifier'
require 'regexp_parser/expression/subexpression'
require 'regexp_parser/expression/sequence'

require 'regexp_parser/expression/classes/alternation'
require 'regexp_parser/expression/classes/anchor'
require 'regexp_parser/expression/classes/backref'
require 'regexp_parser/expression/classes/conditional'
require 'regexp_parser/expression/classes/escape'
require 'regexp_parser/expression/classes/free_space'
require 'regexp_parser/expression/classes/group'
require 'regexp_parser/expression/classes/keep'
require 'regexp_parser/expression/classes/literal'
require 'regexp_parser/expression/classes/property'
require 'regexp_parser/expression/classes/root'
require 'regexp_parser/expression/classes/set'
require 'regexp_parser/expression/classes/type'
