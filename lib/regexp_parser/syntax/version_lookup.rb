# frozen_string_literal: true

module Regexp::Syntax
  VERSION_FORMAT = '\Aruby/\d+\.\d+(\.\d+)?\z'
  VERSION_REGEXP = /#{VERSION_FORMAT}/.freeze
  VERSION_CONST_REGEXP = /\AV\d+_\d+(?:_\d+)?\z/.freeze

  class InvalidVersionNameError < Regexp::Syntax::SyntaxError
    def initialize(name)
      super "Invalid version name '#{name}'. Expected format is '#{VERSION_FORMAT}'"
    end
  end

  class UnknownSyntaxNameError < Regexp::Syntax::SyntaxError
    def initialize(name)
      super "Unknown syntax name '#{name}'."
    end
  end

  module_function

  # Returns the syntax specification class for the given syntax
  # version name. The special names 'any' and '*' return Syntax::Any.
  def for(name)
    return Regexp::Syntax::Any if ['*', 'any'].include?(name.to_s)

    name =~ VERSION_REGEXP || raise(InvalidVersionNameError, name)
    version_const_name = "V#{name.to_s.scan(/\d+/).join('_')}"
    const_get(version_const_name)
  end

  def new(name)
    warn 'Regexp::Syntax.new is deprecated in favor of Regexp::Syntax.for. '\
         'It does not return distinct instances and will be removed in v3.0.0.'
    self.for(name)
  end

  def version_class(name)
    warn 'Regexp::Syntax.version_class is deprecated in favor of Regexp::Syntax.for. '\
         'It will be removed in regexp_parser v3.0.0.'
    self.for(name)
  end

  def supported?(name)
    name =~ VERSION_REGEXP && comparable(name) >= comparable('1.8.6')
  end

  def const_missing(const_name)
    if const_name =~ VERSION_CONST_REGEXP
      return set_fallback_version_class(const_name) ||
             raise(UnknownSyntaxNameError, const_name)
    end
    super
  end

  def set_fallback_version_class(const_name)
    return unless (klass = fallback_version_class(const_name))

    if constants.count { |c| c =~ VERSION_REGEXP } > 1000
      raise Regexp::Syntax::SyntaxError,
            "Unexpected high number of syntax versions defined. "\
            "Do not accept unfiltered user input as Regexp::Syntax version."
    end
    const_set(const_name, klass)
    klass
  end

  def fallback_version_class(version)
    sorted = (specified_versions + [version]).sort_by { |ver| comparable(ver) }
    index = sorted.index(version)
    index > 0 && const_get(sorted[index - 1])
  end

  def specified_versions
    constants.select { |const_name| const_name =~ VERSION_CONST_REGEXP }
  end

  def comparable(name)
    # add .99 to treat versions without a patch value as latest patch version
    Gem::Version.new((name.to_s.scan(/\d+/) << 99).join('.'))
  end
end
