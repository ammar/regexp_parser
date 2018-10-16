require 'spec_helper'

RSpec.describe(Regexp::Syntax) do
  specify('syntax alias 1 8 6') do
    syntax = Regexp::Syntax.new('ruby/1.8.6')

    expect(syntax).to be_a(Regexp::Syntax::V1_8_6)
  end

  specify('syntax alias 1 8 alias') do
    syntax = Regexp::Syntax.new('ruby/1.8')

    expect(syntax).to be_a(Regexp::Syntax::V1_8_6)
  end

  specify('syntax alias 1 9 1') do
    syntax = Regexp::Syntax.new('ruby/1.9.1')

    expect(syntax).to be_a(Regexp::Syntax::V1_9_1)
  end

  specify('syntax alias 1 9 alias') do
    syntax = Regexp::Syntax.new('ruby/1.9')

    expect(syntax).to be_a(Regexp::Syntax::V1_9_3)
  end

  specify('syntax alias 2 0 0') do
    syntax = Regexp::Syntax.new('ruby/2.0.0')

    expect(syntax).to be_a(Regexp::Syntax::V1_9)
  end

  specify('syntax alias 2 0 alias') do
    syntax = Regexp::Syntax.new('ruby/2.0')

    expect(syntax).to be_a(Regexp::Syntax::V2_0_0)
  end

  specify('syntax alias 2 1 alias') do
    syntax = Regexp::Syntax.new('ruby/2.1')

    expect(syntax).to be_a(Regexp::Syntax::V2_0_0)
  end

  specify('syntax alias 2 2 0') do
    syntax = Regexp::Syntax.new('ruby/2.2.0')

    expect(syntax).to be_a(Regexp::Syntax::V2_0_0)
  end

  specify('syntax alias 2 2 10') do
    syntax = Regexp::Syntax.new('ruby/2.2.10')

    expect(syntax).to be_a(Regexp::Syntax::V2_0_0)
  end

  specify('syntax alias 2 2 alias') do
    syntax = Regexp::Syntax.new('ruby/2.2')

    expect(syntax).to be_a(Regexp::Syntax::V2_0_0)
  end

  specify('syntax alias 2 3 0') do
    syntax = Regexp::Syntax.new('ruby/2.3.0')

    expect(syntax).to be_a(Regexp::Syntax::V2_3_0)
  end

  specify('syntax alias 2 3') do
    syntax = Regexp::Syntax.new('ruby/2.3')

    expect(syntax).to be_a(Regexp::Syntax::V2_3_0)
  end

  specify('syntax alias 2 4 0') do
    syntax = Regexp::Syntax.new('ruby/2.4.0')

    expect(syntax).to be_a(Regexp::Syntax::V2_4_0)
  end

  specify('syntax alias 2 4 1') do
    syntax = Regexp::Syntax.new('ruby/2.4.1')

    expect(syntax).to be_a(Regexp::Syntax::V2_4_1)
  end

  specify('syntax alias 2 5 0') do
    syntax = Regexp::Syntax.new('ruby/2.5.0')

    expect(syntax).to be_a(Regexp::Syntax::V2_4_1)
    expect(syntax).to be_a(Regexp::Syntax::V2_5_0)
  end

  specify('syntax alias 2 5') do
    syntax = Regexp::Syntax.new('ruby/2.5')

    expect(syntax).to be_a(Regexp::Syntax::V2_5_0)
  end

  specify('syntax alias 2 6 0') do
    syntax = Regexp::Syntax.new('ruby/2.6.0')

    expect(syntax).to be_a(Regexp::Syntax::V2_5_0)
    expect(syntax).to be_a(Regexp::Syntax::V2_6_0)
  end

  specify('syntax alias 2 6') do
    syntax = Regexp::Syntax.new('ruby/2.6')

    expect(syntax).to be_a(Regexp::Syntax::V2_5_0)
  end

  specify('future alias warning') do
    expect { Regexp::Syntax.new('ruby/5.0') }
      .to output(/This library .* but you are running .* \(feature set of .*\)/)
      .to_stderr
  end
end
