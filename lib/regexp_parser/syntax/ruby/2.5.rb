require File.expand_path('../2.5.1', __FILE__)

module Regexp::Syntax
  module Ruby
    # uses the latest 2.5 release
    class V25 < Regexp::Syntax::Ruby::V251; end
  end
end
