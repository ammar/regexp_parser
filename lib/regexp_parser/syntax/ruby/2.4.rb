require File.expand_path('../2.4.4', __FILE__)

module Regexp::Syntax
  module Ruby
    # uses the latest 2.4 release
    class V24 < Regexp::Syntax::Ruby::V244; end
  end
end
