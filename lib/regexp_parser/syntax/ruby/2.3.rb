require File.expand_path('../2.3.3', __FILE__)

module Regexp::Syntax
  module Ruby
    # uses the latest 2.3 release
    class V23 < Regexp::Syntax::Ruby::V233; end
  end
end
