require File.expand_path('../2.3.2', __FILE__)

module Regexp::Syntax
  module Ruby
    # uses the latest 2.3 release
    class V23 < Regexp::Syntax::Ruby::V232; end
  end
end
