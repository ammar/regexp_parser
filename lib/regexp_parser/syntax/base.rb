module Regexp::Syntax

  class NotImplementedError < SyntaxError
    def initialize(syntax, type, token)
      super "#{syntax.class.name} does not implement: [#{type}:#{token}]"
    end
  end

  # A lookup map of supported types and tokens in a given syntax
  class Base
    def initialize
      @implements = {}

      implements Token::Literal::Type,   Token::Literal::All
      implements Token::FreeSpace::Type, Token::FreeSpace::All
    end

    def implementation
      @implements
    end

    def implements(type, tokens)
      if @implements[type]
        @implements[type] = (@implements[type] + tokens).uniq
      else
        @implements[type] = tokens
      end
    end

    # removes
    def excludes(type, tokens)
      if tokens
        tokens = [tokens] unless tokens.is_a?(Array)
      end

      if @implements[type]
        if tokens
          @implements[type] = @implements[type] - tokens
          @implements[type] = nil if @implements[type].empty?
        else
          @implements[type] = nil
        end
      end
    end

    def implements?(type, token)
      return true if @implements[type] and @implements[type].include?(token)
      false
    end
    alias :check? :implements?

    def implements!(type, token)
      raise NotImplementedError.new(self, type, token) unless
        implements?(type, token)
    end
    alias :check! :implements!

    def normalize(type, token)
      case type
      when :group
        normalize_group(type, token)
      when :backref
        normalize_backref(type, token)
      else
        [type, token]
      end
    end

    def normalize_group(type, token)
      case token
      when :named_ab, :named_sq
        [:group, :named]
      else
        [type, token]
      end
    end

    def normalize_backref(type, token)
      case token
      when :name_ref_ab, :name_ref_sq
        [:backref, :name_ref]
      when :name_call_ab, :name_call_sq
        [:backref, :name_call]
      when :name_nest_ref_ab, :name_nest_ref_sq
        [:backref, :name_nest_ref]
      when :number_ref_ab, :number_ref_sq
        [:backref, :number_ref]
      when :number_call_ab, :number_call_sq
        [:backref, :number_call]
      when :number_rel_ref_ab, :number_rel_ref_sq
        [:backref, :number_rel_ref]
      when :number_rel_call_ab, :number_rel_call_sq
        [:backref, :number_rel_call]
      when :number_nest_ref_ab, :number_nest_ref_sq
        [:backref, :number_nest_ref]
      else
        [type, token]
      end
    end
  end

end
