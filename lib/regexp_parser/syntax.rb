module Regexp::Syntax

  def self.find(name)
    return Regexp::Syntax::Any.new if
      ['*', 'any'].include?( name.to_s )

    path = File.expand_path('../syntax', __FILE__)

    full = "#{path}/#{name}"
    full = (full[-1, 3] == '.rb') ? full : "#{full}.rb"

    raise "Unsupported syntax #{name}" unless File.exist?(full)
    require full

    case name
      when 'posix/bre'; syntax = Regexp::Syntax::POSIX::BRE.new
      when 'posix/ere'; syntax = Regexp::Syntax::POSIX::ERE.new

      when 'ruby/1.8';  syntax = Regexp::Syntax::Ruby::V18.new
      when 'ruby/1.9';  syntax = Regexp::Syntax::Ruby::V19.new

      else
        raise "Unexpected syntax name #{name}"
    end
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

    def check?(type, token)
      @implements[type] and @implements[type].include?(token)
    end

    def check!(type, token)
      raise "#{self.class.name} does not implement: [#{type} #{token}]" unless
        check?(type, token)
    end
  end

  # A syntax that passes any flavor
  class Any < Base
    def initialize
      @implements = { :* => [:*] }
    end

    def implements(type, tokens); true end

    def check?(type, token); true end
    def check!(type, token); true end
  end

end
