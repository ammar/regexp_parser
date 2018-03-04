require File.expand_path('../2.6.0', __FILE__)

module Regexp::Syntax
  module Ruby
    # uses the latest 2.6 release
    class V26 < Regexp::Syntax::Ruby::V260; end
  end
end
