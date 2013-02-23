module Regexp::Expression

  class Base
    attr_accessor :type, :token
    attr_accessor :level, :text, :ts

    attr_accessor :quantifier
    attr_accessor :options

    def initialize(token)
      @type         = token.type
      @token        = token.token
      @text         = token.text
      @ts           = token.ts
      @level        = token.level
      @options      = nil
    end

    def clone
      copy = self.dup

      copy.text       = (self.text        ? self.text.dup         : nil)
      copy.options    = (self.options     ? self.options.dup      : nil)
      copy.quantifier = (self.quantifier  ? self.quantifier.clone : nil)

      copy
    end

    def to_re(format = :full)
      ::Regexp.new(to_s(format))
    end

    def starts_at
      @ts
    end

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
      s = ''

      case format
      when :base
        s << @text.dup
      else
        s << @text.dup
        s << @quantifier if quantified?
      end

      s
    end

    def terminal?
      !respond_to?(:expressions)
    end

    def quantify(token, text, min = nil, max = nil, mode = :greedy)
      @quantifier = Quantifier.new(token, text, min, max, mode)
    end

    def quantified?
      not @quantifier.nil?
    end

    def quantity
      return [nil,nil] unless quantified?
      [@quantifier.min, @quantifier.max]
    end

    def greedy?
      quantified? and @quantifier.mode == :greedy
    end

    def reluctant?
      quantified? and @quantifier.mode == :reluctant
    end
    alias :lazy? :reluctant?

    def possessive?
      quantified? and @quantifier.mode == :possessive
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

  def self.parsed(exp)
    case exp
    when String
      Regexp::Parser.parse(exp)
    when Regexp
      Regexp::Parser.parse(exp.source)
    when Regexp::Expression
      exp
    else
      raise "Expression.parsed accepts a String, Regexp, or " +
            "a Regexp::Expression as a value for exp, but it " +
            "was given #{exp.class.name}."
    end
  end

end # module Regexp::Expression


[ # Order is important
  '/expression/*.rb',
  '/expression/classes/*.rb',
].each do |path|
  Dir[File.join(File.dirname(__FILE__), path)].each {|f| require f }
end
