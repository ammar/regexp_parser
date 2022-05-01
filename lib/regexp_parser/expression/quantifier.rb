module Regexp::Expression
  # TODO: in v3.0.0, drop @full_token and inherit from Expression::Base,
  # re-using its initializer and attr_accessors, but raise in #quantifier=
  # and #quantify or introduce an Expression::Quantifiable intermediate class.
  # Or actually allow chaining as a more concise but tricky solution than PR#69.
  class Quantifier
    MODES = %i[greedy possessive reluctant]

    attr_reader :min, :max, :mode

    # START shareable with Expression::Base
    attr_accessor :type, :token, :text, :ts, :options
    attr_accessor :level, :set_level, :conditional_level, :nesting_level

    def initialize(*args)
      if args.count == 1 || args.count == 2
        token                  = args[0]
        self.type              = token.type
        self.text              = token.text
        self.ts                = token.ts
        self.level             = token.level
        self.set_level         = token.set_level
        self.conditional_level = token.conditional_level
        self.nesting_level     = 0
        self.options           = args[1] || {}

        # TODO: in v3.0.0, remove @full_token and set self.token = token.token,
        #       maybe by simply inheriting the initializer from Expression::Base
        self.token             = token.token.to_s.sub(/_(greedy|possessive|reluctant)/, '').to_sym
        @full_token            = token.token

        @mode                  = (token.token[/greedy|reluctant|possessive/] || :greedy).to_sym
        case token.token
        when /zero_or_one/  then @min, @max = 0, 1
        when /zero_or_more/ then @min, @max = 0, -1
        when /one_or_more/  then @min, @max = 1, -1
        when :interval
          int_min = token.text[/\{(\d*)/, 1]
          int_max = token.text[/,?(\d*)\}/, 1]
          @min, @max = int_min.to_i, (int_max.empty? ? -1 : int_max.to_i)
        end
      elsif args.count == 4 || args.count == 5
        warn "#{self.class}.new with 4+ arguments is deprecated and will be "\
             'removed in v3.0.0. Please pass a Regexp::Token and options Hash.'
        @token = args[0]
        @text  = args[1]
        @min   = args[2]
        @max   = args[3]
        @mode  = args[4] || :greedy
      else
        raise ArgumentError, "wrong number of arguments (given #{args.count}, expected 1..2)"
      end
    end

    def initialize_copy(orig)
      @text = orig.text.dup
      super
    end

    def to_s(_format = nil)
      text.dup
    end
    alias :to_str :to_s
    # END shareable with Expression::Base

    def to_h
      {
        token: token,
        text:  text,
        mode:  mode,
        min:   min,
        max:   max,
      }
    end

    MODES.each do |mode|
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{mode}?
          mode.equal?(:#{mode})
        end
      RUBY
    end
    alias :lazy? :reluctant?

    def ==(other)
      other.class == self.class &&
        other.token == token &&
        other.mode == mode &&
        other.min == min &&
        other.max == max
    end
    alias :eq :==
  end
end
