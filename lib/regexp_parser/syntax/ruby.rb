module Regexp::Syntax
  module Ruby
    module_function

    VERSION_FORMAT = '\Aruby/\d+\.\d+(\.\d+)?\z'
    VERSION_REGEXP = /#{VERSION_FORMAT}/
    VERSION_CONST_FORMAT = /\AV\d{2,}\z/

    def version_class(version)
      version =~ VERSION_REGEXP || raise(InvalidVersionNameError, version)
      version_const_name = version_const_name(version)
      const_get(version_const_name) || raise(UnknownSyntaxNameError, version)
    end

    def const_missing(const_name)
      if const_name =~ VERSION_CONST_FORMAT
        return fallback_version_class(version_string(const_name))
      end
      super
    end

    def fallback_version_class(version)
      sorted_versions = (specified_versions + [version]).sort_by do |key|
        # let versions without a patch value fall back to latest patch version
        key += '.99' if key.count('.') == 1
        comparable_version(key)
      end
      return if (version_index = sorted_versions.index(version)) < 1

      next_lower_version = sorted_versions[version_index - 1]
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

    def version_const_name(version_string)
      "V#{version_string.scan(/\d+/).join}"
    end

    def comparable_version(version)
      Gem::Version.new(version.sub('ruby/', ''))
    end
  end
end
