module Regexp::Syntax
  require File.expand_path('../syntax/tokens', __FILE__)

  SYNTAX_SPEC_ROOT = File.expand_path('../syntax', __FILE__)

  # Loads, and instantiates an instance of the syntax specification class for
  # the given syntax flavor name. The special names 'any' and '*' returns a
  # instance of Syntax::Any. See below for more details.
  def self.new(name)
    return Regexp::Syntax::Any.new if
      ['*', 'any'].include?( name.to_s )

    self.load(name)

    case name
      when 'posix/bre';   syntax = Regexp::Syntax::POSIX::BRE.new
      when 'posix/ere';   syntax = Regexp::Syntax::POSIX::ERE.new

      when 'ruby/1.8';    syntax = Regexp::Syntax::Ruby::V18.new

      when 'ruby/1.9.1';  syntax = Regexp::Syntax::Ruby::V191.new
      when 'ruby/1.9.2';  syntax = Regexp::Syntax::Ruby::V192.new
      when 'ruby/1.9.3';  syntax = Regexp::Syntax::Ruby::V193.new
      when 'ruby/1.9';    syntax = Regexp::Syntax::Ruby::V19.new

      else
        raise "Unexpected syntax name #{name}"
    end
  end

  # Checks if the named syntax has a specification class file, and requires
  # it if it does. Downcases names, and adds the .rb extension if omitted.
  def self.load(name)
    full = "#{SYNTAX_SPEC_ROOT}/#{name.downcase}"
    full = (full[-1, 3] == '.rb') ? full : "#{full}.rb"

    # TODO: define and use better exceptions
    raise "Unsupported syntax #{name}" unless File.exist?(full)
    require full
  end

  # A lookup map of supported types and tokens in a given syntax
  class Base
    def initialize
      @implements = {}

      implements :literal, [:literal]
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
      raise "#{self.class.name} does not implement: [#{type}:#{token}]" unless
        implements?(type, token)
    end
    alias :check! :implements!

    def normalize(type, token)
      case type
      when :group
        normalize_group(type, token)
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
