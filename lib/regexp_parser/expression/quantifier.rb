module Regexp::Expression
  # TODO: in v3.0.0, maybe put Shared back into Base, and inherit from Base and
  # call super in #initialize, but raise in #quantifier= and #quantify,
  # or introduce an Expression::Quantifiable intermediate class.
  # Or actually allow chaining as a more concise but tricky solution than PR#69.
  class Quantifier
    include Regexp::Expression::Shared

    MODES = %i[greedy possessive reluctant]

    attr_reader :min, :max, :mode

    def initialize(*args)
      init_from_token_and_options(*args)
      @mode = (token.to_s[/greedy|reluctant|possessive/] || :greedy).to_sym
      @min, @max = minmax
      # TODO: remove in v3.0.0, stop removing parts of #token (?)
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
