require File.expand_path('../syntax/tokens', __FILE__)

module Regexp::Syntax

  class SyntaxError < StandardError
    def initialize(what)
      super what
    end
  end

  class UnknownSyntaxNameError < SyntaxError
    def initialize(name)
      super "Unknown syntax name '#{name}'. Forgot to add it in the case statement?"
    end
  end

  class MissingSyntaxSpecError < SyntaxError
    def initialize(name)
      super "Missing syntax specification file for '#{name}'"
    end
  end

  class NotImplementedError < SyntaxError
    def initialize(syntax, type, token)
      super "#{syntax.class.name} does not implement: [#{type}:#{token}]"
    end
  end

  SYNTAX_SPEC_ROOT = File.expand_path('../syntax', __FILE__)

  # Loads, and instantiates an instance of the syntax specification class for
  # the given syntax flavor name. The special names 'any' and '*' returns a
  # instance of Syntax::Any. See below for more details.
  def self.new(name)
    return Regexp::Syntax::Any.new if
      ['*', 'any'].include?( name.to_s )

    self.load(name)
    self.instantiate(name)
  end

  def self.instantiate(name)
    case name
      # Ruby 1.8.x (NOTE: 1.8.6 is no longer a supported runtime,
      # but its regex features are still recognized.)
      when 'ruby/1.8.6';  syntax = Regexp::Syntax::Ruby::V186.new
      when 'ruby/1.8.7';  syntax = Regexp::Syntax::Ruby::V187.new

      # alias for the latest 1.8 implementation
      when 'ruby/1.8';    syntax = Regexp::Syntax::Ruby::V18.new

      # Ruby 1.9.x
      when 'ruby/1.9.1';  syntax = Regexp::Syntax::Ruby::V191.new
      when 'ruby/1.9.2';  syntax = Regexp::Syntax::Ruby::V192.new
      when 'ruby/1.9.3';  syntax = Regexp::Syntax::Ruby::V193.new

      # alias for the latest 1.9 implementation
      when 'ruby/1.9';    syntax = Regexp::Syntax::Ruby::V19.new

      # Ruby 2.0.x
      when 'ruby/2.0.0';  syntax = Regexp::Syntax::Ruby::V200.new

      # aliases for the latest 2.0 implementations
      when 'ruby/2.0';    syntax = Regexp::Syntax::Ruby::V20.new

      # Ruby 2.1.x
      when 'ruby/2.1.0';  syntax = Regexp::Syntax::Ruby::V210.new
      when 'ruby/2.1.2';  syntax = Regexp::Syntax::Ruby::V212.new
      when 'ruby/2.1.3';  syntax = Regexp::Syntax::Ruby::V213.new
      when 'ruby/2.1.4';  syntax = Regexp::Syntax::Ruby::V214.new
      when 'ruby/2.1.5';  syntax = Regexp::Syntax::Ruby::V215.new
      when 'ruby/2.1.6';  syntax = Regexp::Syntax::Ruby::V216.new
      when 'ruby/2.1.7';  syntax = Regexp::Syntax::Ruby::V217.new
      when 'ruby/2.1.8';  syntax = Regexp::Syntax::Ruby::V218.new

      # aliases for the latest 2.1 implementations
      when 'ruby/2.1';    syntax = Regexp::Syntax::Ruby::V21.new

      # Ruby 2.2.x
      when 'ruby/2.2.0';  syntax = Regexp::Syntax::Ruby::V220.new
      when 'ruby/2.2.1';  syntax = Regexp::Syntax::Ruby::V221.new
      when 'ruby/2.2.2';  syntax = Regexp::Syntax::Ruby::V222.new
      when 'ruby/2.2.3';  syntax = Regexp::Syntax::Ruby::V223.new
      when 'ruby/2.2.4';  syntax = Regexp::Syntax::Ruby::V224.new

      # aliases for the latest 2.2 implementations
      when 'ruby/2.2';    syntax = Regexp::Syntax::Ruby::V22.new

      # Ruby 2.3.x
      when 'ruby/2.3.0';  syntax = Regexp::Syntax::Ruby::V230.new

      # alias for the latest 2.3 implementation
      when 'ruby/2.3';    syntax = Regexp::Syntax::Ruby::V23.new

      else
        raise UnknownSyntaxNameError.new(name)
    end
  end

  # Checks if the named syntax has a specification class file, and requires
  # it if it does. Downcases names, and adds the .rb extension if omitted.
  def self.load(name)
    full = "#{SYNTAX_SPEC_ROOT}/#{name.downcase}"
    full = (full[-1, 3] == '.rb') ? full : "#{full}.rb"

    raise MissingSyntaxSpecError.new(name) unless File.exist?(full)
    require full
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

  # A syntax that always returns true, passing all tokens as implemented. This
  # is useful during development, testing, and should be useful for some types
  # of transformations as well.
  class Any < Base
    def initialize
      @implements = { :* => [:*] }
    end

    def implements?(type, token) true end
    def implements!(type, token) true end
  end

end
