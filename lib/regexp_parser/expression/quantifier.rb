module Regexp::Expression
  class Quantifier < Base
    MODES = %i[greedy possessive reluctant]

    attr_reader :min, :max, :mode

    def initialize(*args)
      super(*args)
      @mode = (token.to_s[/greedy|reluctant|possessive/] || :greedy).to_sym
      @min, @max = minmax
      self.token = token.to_s.sub(/_(greedy|possessive|reluctant)/, '').to_sym
    end

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

    def quantify(*_args)
      raise Regexp::Parser::Error, 'Can not quantify a quantifier'
    end

    private

    def minmax
      case token
      when /zero_or_one/  then [0, 1]
      when /zero_or_more/ then [0, -1]
      when /one_or_more/  then [1, -1]
      when :interval
        int_min = text[/\{(\d*)/, 1]
        int_max = text[/,?(\d*)\}/, 1]
        [int_min.to_i, (int_max.empty? ? -1 : int_max.to_i)]
      end
    end
  end
end
