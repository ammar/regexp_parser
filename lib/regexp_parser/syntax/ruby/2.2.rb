require File.expand_path('../2.2.0', __FILE__)

module Regexp::Syntax
  module Ruby
    # uses the latest 2.2 release
    class V22 < Regexp::Syntax::Ruby::V220; end
  end
end
