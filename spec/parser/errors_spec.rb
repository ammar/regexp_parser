require 'spec_helper'

RSpec.describe('Parsing errors') do
  let(:rp) { Regexp::Parser.new }
  before { rp.parse(/foo/) }

  specify('parser unknown token type') do
    expect { rp.send(:parse_token, Regexp::Token.new(:foo, :bar)) }
      .to raise_error(Regexp::Parser::UnknownTokenTypeError)
  end

  specify('parser unknown set token') do
    expect { rp.send(:parse_token, Regexp::Token.new(:set, :foo)) }
      .to raise_error(Regexp::Parser::UnknownTokenError)
  end

  specify('parser unknown meta token') do
    expect { rp.send(:parse_token, Regexp::Token.new(:meta, :foo)) }
      .to raise_error(Regexp::Parser::UnknownTokenError)
  end

  specify('parser unknown character type token') do
    expect { rp.send(:parse_token, Regexp::Token.new(:type, :foo)) }
      .to raise_error(Regexp::Parser::UnknownTokenError)
  end

  specify('parser unknown unicode property token') do
    expect { rp.send(:parse_token, Regexp::Token.new(:property, :foo)) }
      .to raise_error(Regexp::Parser::UnknownTokenError)
  end

  specify('parser unknown unicode nonproperty token') do
    expect { rp.send(:parse_token, Regexp::Token.new(:nonproperty, :foo)) }
      .to raise_error(Regexp::Parser::UnknownTokenError)
  end

  specify('parser unknown anchor token') do
    expect { rp.send(:parse_token, Regexp::Token.new(:anchor, :foo)) }
      .to raise_error(Regexp::Parser::UnknownTokenError)
  end

  specify('parser unknown quantifier token') do
    expect { rp.send(:parse_token, Regexp::Token.new(:quantifier, :foo)) }
      .to raise_error(Regexp::Parser::UnknownTokenError)
  end

  specify('parser unknown group open token') do
    expect { rp.send(:parse_token, Regexp::Token.new(:group, :foo)) }
      .to raise_error(Regexp::Parser::UnknownTokenError)
  end
end
