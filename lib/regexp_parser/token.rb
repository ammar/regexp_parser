class Regexp

  TOKEN_KEYS = [
    :type,
    :token,
    :text,
    :ts,
    :te,
    :level,
    :set_level,
    :conditional_level
  ].freeze

  Token = Struct.new(*TOKEN_KEYS) do
    def initialize(*)
      super

      @previous = @next = nil
    end

    def offset
      [self.ts, self.te]
    end

    def length
      self.te - self.ts
    end

    def next(exp = nil)
      if exp
        @next = exp
      else
        @next
      end
    end

    def previous(exp = nil)
      if exp
        @previous = exp
      else
        @previous
      end
    end

    if RUBY_VERSION < '2.0.0'
      def to_h
        hash = {}

        members.each do |member|
          hash[member.to_sym] = self.send(member.to_sym)
        end

        hash
      end
    end
  end

end
