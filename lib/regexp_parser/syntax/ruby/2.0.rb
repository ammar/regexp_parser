require File.expand_path('../2.0.0', __FILE__)

module Regexp::Syntax
  module Ruby
    # use the last 2.0 release as the base
    class V20 < Regexp::Syntax::Ruby::V200; end
  end
end
