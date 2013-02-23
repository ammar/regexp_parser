#require File.expand_path("../extras", __FILE__)

RS = Regexp::Scanner
RL = Regexp::Lexer
RP = Regexp::Parser
RE = Regexp::Expression
RR = Regexp::Runner
RM = Regexp::Matcher

include Regexp::Expression

module Regexp::Expression
  module Scope
    Any = { :* => :* }

    All = {
      :anchor      => [:*],
      :literal     => [:*],
      :assertion   => [:*],
      :backref     => [:*],
      :set         => [:*],
      :subset      => [:*],
      :type        => [:*],
      :escape      => [:*],
      :group       => [:*],
      :meta        => [:*],
      :property    => [:*],
      :nonproperty => [:*],
      :expression  => [:*],
    }
  end

  class Base
  end

  class Subexpression
  end

  class Root
  end
end
