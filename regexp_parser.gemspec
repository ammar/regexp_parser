require 'yaml'

Gem::Specification.new do |gem|
  gem.name          = 'regexp_parser'
  gem.version       = YAML.load(File.read('VERSION.yml')).values.compact.join('.')

  gem.summary       = "Scanner, lexer, parser for ruby's regular expressions"
  gem.description   = 'A library for tokenizing, lexing, and parsing Ruby regular expressions.'
  gem.homepage      = 'http://github.com/ammar/regexp_parser'
  gem.metadata      = { 'issue_tracker' => 'https://github.com/ammar/regexp_parser/issues' }

  gem.authors       = ['Ammar Ali']
  gem.email         = ['ammarabuali@gmail.com']

  gem.license       = 'MIT'

  gem.require_paths = ['lib']

  gem.files         = Dir.glob('{lib,test}/**/*.rb') +
                      Dir.glob('lib/**/*.rl') +
                      %w(VERSION.yml Rakefile LICENSE README.md ChangeLog)

  gem.test_files    = Dir.glob('test/**/*.rb')

  gem.rdoc_options  = ["--inline-source", "--charset=UTF-8"]

  gem.platform      = Gem::Platform::RUBY

  gem.required_ruby_version = '>= 1.8.7'
end
