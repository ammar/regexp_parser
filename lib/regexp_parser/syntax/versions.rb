# Ruby 1.8.x is no longer a supported runtime,
# but its regex features are still recognized.
#
# Aliases for the latest patch version are provided as 'ruby/n.n',
# e.g. 'ruby/1.9' refers to Ruby v1.9.3.
module Regexp::Syntax
  version_file_paths = Dir[File.expand_path('../ruby/*.rb', __FILE__)]
  version_file_paths.each { |path| require path }
  VERSIONS = version_file_paths.map { |path| path[%r{(ruby/.*)\.rb}, 1] }
end
