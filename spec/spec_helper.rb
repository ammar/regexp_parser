$VERBOSE = true

require 'leto'
require 'regexp_property_values'
require_relative 'support/capturing_stderr'
require_relative 'support/shared_examples'

req_warn = capturing_stderr { @required_now = require('regexp_parser') }
req_warn.empty? || fail("requiring parser generated warnings:\n#{req_warn}")
@required_now || fail("regexp_parser was required earlier than expected")

RS = Regexp::Scanner
RL = Regexp::Lexer
RP = Regexp::Parser
RE = Regexp::Expression
T = Regexp::Syntax::Token

include Regexp::Expression

def ruby_version_at_least(version)
  Gem::Version.new(RUBY_VERSION.dup) >= Gem::Version.new(version)
end

RSpec.configure do |config|
  config.around(:example) do |example|
    # treat unexpected warnings as failures
    expect { example.run }.not_to output.to_stderr
  end
end

def s(klass, text = '', *children)
  exp = klass.construct(text: text.to_s)
  children.each { |child| exp.expressions << child }
  exp
end

def regexp_with_all_features
  return /dummy/ unless ruby_version_at_least('2.4.1')

  Regexp.new(<<-'REGEXP', Regexp::EXTENDED)
    \A
    a++
    (?:
      \b {2}
      (?>
        c ??
        😀😀😀
        # 😄😄😄
        (?# 😃😃😃 )
        (
          \d *+
          (
            ALT1
            |
            ALT2
          )
        ) {004}
        |
        [ä-ü&&ö[:ascii:]\p{thai}] {6}
        |
        \z
      )
      (?=lm{8}) ?+
      \K
      (?~
        \1
        \g<-1> {10}
        \uFFFF
        \012
      )
      (?(1)
        BRANCH1
        |
        BRANCH2
      )
    )
  REGEXP
end
