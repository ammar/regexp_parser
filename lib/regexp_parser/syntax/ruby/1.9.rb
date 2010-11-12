require File.expand_path('../1.9.3', __FILE__)

module Regexp::Syntax
  module Ruby
    # uses the latest 1.9 release
    class V19 < Regexp::Syntax::Ruby::V193; end
  end
end
