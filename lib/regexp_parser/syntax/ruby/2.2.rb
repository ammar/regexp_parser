require File.expand_path('../2.2.9', __FILE__)

module Regexp::Syntax
  module Ruby
    # uses the latest 2.2 release
    class V22 < Regexp::Syntax::Ruby::V229; end
  end
end
