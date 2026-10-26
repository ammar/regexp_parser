# frozen_string_literal: true

require_relative 'error'

module Regexp::Syntax
  class SyntaxError < Regexp::Parser::Error; end
end

require_relative 'syntax/token'
require_relative 'syntax/base'
require_relative 'syntax/any'
require_relative 'syntax/version_lookup'
require_relative 'syntax/versions'

# Make all versions Ractor-safe
Regexp::Syntax.constants.each do |const|
  obj = Regexp::Syntax.const_get(const)
  obj.freeze_features if obj.instance_of?(Class) && obj < Regexp::Syntax::Base
end
