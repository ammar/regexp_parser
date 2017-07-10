module Regexp::Syntax

  VERSIONS = [
    # Ruby 1.8.x (NOTE: 1.8.6 is no longer a supported runtime,
    # but its regex features are still recognized.)
    'ruby/1.8.6',
    'ruby/1.8.7',

    # alias for the latest 1.8 implementation
    'ruby/1.8',

    # Ruby 1.9.x
    'ruby/1.9.1',
    'ruby/1.9.2',
    'ruby/1.9.3',

    # alias for the latest 1.9 implementation
    'ruby/1.9',

    # Ruby 2.0.x
    'ruby/2.0.0',

    # alias for the latest 2.0 implementations
    'ruby/2.0',

    # Ruby 2.1.x
    'ruby/2.1.0',
    'ruby/2.1.2',
    'ruby/2.1.3',
    'ruby/2.1.4',
    'ruby/2.1.5',
    'ruby/2.1.6',
    'ruby/2.1.7',
    'ruby/2.1.8',
    'ruby/2.1.9',
    'ruby/2.1.10',

    # alias for the latest 2.1 implementations
    'ruby/2.1',

    # Ruby 2.2.x
    'ruby/2.2.0',
    'ruby/2.2.1',
    'ruby/2.2.2',
    'ruby/2.2.3',
    'ruby/2.2.4',
    'ruby/2.2.5',
    'ruby/2.2.6',

    # alias for the latest 2.2 implementations
    'ruby/2.2',

    # Ruby 2.3.x
    'ruby/2.3.0',
    'ruby/2.3.1',
    'ruby/2.3.2',
    'ruby/2.3.3',
    'ruby/2.3.4',

    # alias for the latest 2.3 implementation
    'ruby/2.3',

    # Ruby 2.4.x
    'ruby/2.4.0',
    'ruby/2.4.1',

    # alias for the latest 2.4 implementation
    'ruby/2.4',
  ]

end

Regexp::Syntax::VERSIONS.each do |version|
  require File.expand_path("../#{version}", __FILE__)
end
