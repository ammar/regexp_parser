require File.expand_path('../2.4.1', __FILE__)

module Regexp::Syntax
  module Ruby
    # uses the latest 2.4 release
    class V24 < Regexp::Syntax::Ruby::V241; end
  end
end
