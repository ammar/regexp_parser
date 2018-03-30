require File.expand_path('../syntax/tokens', __FILE__)
require File.expand_path('../syntax/base', __FILE__)
require File.expand_path('../syntax/any', __FILE__)
require File.expand_path('../syntax/ruby', __FILE__)
require File.expand_path('../syntax/versions', __FILE__)

module Regexp::Syntax
  class SyntaxError < StandardError
    def initialize(what)
      super what
    end
  end

  class UnknownSyntaxNameError < SyntaxError
    def initialize(name)
      super "Unknown syntax name '#{name}'."
    end
  end

  class InvalidVersionNameError < SyntaxError
    def initialize(name)
      super "Invalid version name '#{name}'. Expected format is '#{Ruby::VERSION_FORMAT}'"
    end
  end

  # Loads and instantiates an instance of the syntax specification class for
  # the given syntax version name. The special names 'any' and '*' return an
  # instance of Syntax::Any.
  def self.new(name)
    return Regexp::Syntax::Any.new if
      ['*', 'any'].include?( name.to_s )

    raise UnknownSyntaxNameError.new(name) unless supported?(name)

    version_class(name).new
  end

  def self.supported?(name)
    begin
      !!version_class(name)
    rescue UnknownSyntaxNameError
      false
    end
  end

  def self.version_class(version)
    Ruby.version_class(version)
  end
end
