require File.expand_path('../2.1.7', __FILE__)

module Regexp::Syntax
  module Ruby
    # uses the latest 2.1 release
    class V21 < Regexp::Syntax::Ruby::V217; end
  end
end
