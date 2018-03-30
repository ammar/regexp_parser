module Regexp::Syntax::Ruby
  module_function

  VERSION_FORMAT = '\Aruby/\d+\.\d+(\.\d+)?\z'
  VERSION_REGEXP = /#{VERSION_FORMAT}/
  VERSION_CONST_FORMAT = /\AV\d{2,}\z/

  def version_class(version)
    raise Regexp::Syntax::InvalidVersionNameError.new(version) unless
      version =~ VERSION_REGEXP

    version_const_name = version.scan(/\d+/).join

    const_name = "Regexp::Syntax::Ruby::V#{version_const_name}"

    if RUBY_VERSION >= '2.0.0'
      Kernel.const_get(const_name)
    else
      Object.module_eval(const_name, __FILE__, __LINE__)
    end
  end

  def const_missing(const_name)
    if const_name =~ VERSION_CONST_FORMAT
      fallback_version_class(version_string(const_name))
    else
      super
    end
  end

  def fallback_version_class(version)
    # ensure versions without a patch value fall back to latest patch version
    version += '.99' if version.count('.') < 2

    raise Regexp::Syntax::UnknownSyntaxNameError.new(version) if
      comparable_version(version) < comparable_version('1.8.6')

    sorted_versions = (specified_versions + [version])
                      .sort_by { |key| comparable_version(key) }
    next_lower_version = sorted_versions[sorted_versions.index(version) - 1]

    version_class(next_lower_version)
  end

  def specified_versions
    constants.inject([]) do |arr, const|
      arr << version_string(const) if const =~ VERSION_CONST_FORMAT
      arr
    end
  end

  def version_string(version_const)
    name = version_const.to_s.split('::').last.delete('V')
    'ruby/' + [name[0], name[1], name[2..-1]].reject(&:empty?).join('.')
  end

  def comparable_version(version)
    Gem::Version.new(version.sub('ruby/', ''))
  end
end
