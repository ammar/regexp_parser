require File.expand_path('../syntax/tokens', __FILE__)
require File.expand_path('../syntax/base', __FILE__)
require File.expand_path('../syntax/any', __FILE__)
require File.expand_path('../syntax/versions', __FILE__)

module Regexp::Syntax

  VERSION_FORMAT = '\Aruby/\d+\.\d+(\.\d+)?\z'
  VERSION_REGEXP = /#{VERSION_FORMAT}/

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

  class InvalidVersionNameError < SyntaxError
    def initialize(name)
      super "Invalid version name '#{name}'. Expected format is '#{VERSION_FORMAT}'"
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
    VERSIONS.include?(name)
  end

  def self.version_class(version)
    raise InvalidVersionNameError.new(version) unless
      version =~ VERSION_REGEXP

    version_const_name = version.scan(/\d+/).join

    const_name = "Regexp::Syntax::Ruby::V#{version_const_name}"

    if RUBY_VERSION >= '2.0.0'
      Kernel.const_get(const_name)
    else
      Object.module_eval(const_name, __FILE__, __LINE__)
    end
  end

end
