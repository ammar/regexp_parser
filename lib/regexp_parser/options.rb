require 'regexp_parser/error'

class Regexp
  #
  # An immutable set of regular expression options.
  #
  # Supports casting from and to many data types.
  #
  # Usage example:
  #   opts = Regexp::Options.new(//mx) # or new([:m, :x]), or new('mx'),..
  #   opts.m? # => true
  #   opts.multiline? # => true
  #   opts.to_s # => 'mx'
  #   Regexp.new('foo', opts) # => /foo/mx
  #
  # Note: Internally, this is using a three-valued logic (true/false/nil),
  # to differentiate between unset (nil) and explicitly disabled (false)
  # options. This is reflected in @data and the return value of #to_h.
  #
  class Options
    BASIC = { i: Regexp::IGNORECASE, m: Regexp::MULTILINE, x: Regexp::EXTENDED }

    ROOT_ENCODING = { n: Regexp::NOENCODING }
    ROOT_IGNORED = { o: 0 }
    ROOT = BASIC.merge(ROOT_ENCODING).merge(ROOT_IGNORED)

    SUBEXP_ENCODING = { a: 0, d: 0, u: 0 }
    SUBEXP = BASIC.merge(SUBEXP_ENCODING)

    VALID = ROOT.merge(SUBEXP)

    class Error < Regexp::Parser::Error; end

    def initialize(arg = {})
      @data = {}
      klass = arg.class
      if klass == ::Hash || klass == self.class
        @data.merge!(arg.to_h)
      elsif klass == ::Regexp # e.g. `/foo/mx`
        ROOT.each { |k, v| @data[k] = true if arg.options & v != 0 }
      elsif klass == ::Integer # e.g. `Regexp::MULTILINE | Regexp::EXTENDED`
        ROOT.each { |k, v| @data[k] = true if arg & v != 0 }
      elsif klass == ::String # e.g. `'mx'`
        arg.chars.each { |c| @data[c.to_sym] = true }
      elsif klass == ::Array # e.g. `[:m, :x]` (parser regopt node children)
        arg.each { |e| @data[e.to_sym] = true }
      else
        raise Error, "Options takes Regexp/Int/String/Array/Hash, got #{klass}"
      end
      (bad = @data.keys - VALID.keys).empty? or
        raise Error, "unkown Regexp option(s) #{bad} (known: #{VALID.keys})"
    end

    %i[[] hash partition to_h].each do |method|
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{method}(*args, &block)
          @data.#{method}(*args, &block)
        end
      RUBY
    end

    def ==(other)
      (other.is_a?(self.class) || other.is_a?(Hash)) && @data == other.to_h
    end

    alias :=== :==
    alias :eql? :==

    def inspect
      "#<#{self.class}: #{@data} >"
    end

    # returns e.g. [:m, :x], for parser interop
    def to_a
      @data.each_with_object([]) { |(k, v), a| a << k if v }
    end

    # returns regopt integer, for use in Regexp::new constructor
    def to_i
      @data.inject(0) { |a, (k, v)| a | (v && ROOT[k] || 0) }
    end

    # returns e.g. 'mx', for use in eval and the like
    def to_s
      to_a.join
    end

    # used in Parser and Scanner to decide precedence of custom options
    def self.choose(input, custom_options)
      if custom_options
        new(custom_options)
      elsif input.is_a?(Regexp)
        new(input.options)
      else
        new
      end
    end

    module Shorthands
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

      def options
        self
      end
    end
    include Shorthands
  end
end
