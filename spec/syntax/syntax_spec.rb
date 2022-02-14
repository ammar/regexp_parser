require 'spec_helper'

RSpec.describe(Regexp::Syntax) do
  describe('::new') do
    it { expect(Regexp::Syntax.new('ruby/1.8.6')).to eq  Regexp::Syntax::V1_8_6 }
    it { expect(Regexp::Syntax.new('ruby/1.8')).to eq    Regexp::Syntax::V1_8_6 }
    it { expect(Regexp::Syntax.new('ruby/1.9.1')).to eq  Regexp::Syntax::V1_9_1 }
    it { expect(Regexp::Syntax.new('ruby/1.9')).to eq    Regexp::Syntax::V1_9_3 }
    it { expect(Regexp::Syntax.new('ruby/2.0.0')).to eq  Regexp::Syntax::V2_0_0 }
    it { expect(Regexp::Syntax.new('ruby/2.0')).to eq    Regexp::Syntax::V2_0_0 }
    it { expect(Regexp::Syntax.new('ruby/2.1')).to eq    Regexp::Syntax::V2_0_0 }
    it { expect(Regexp::Syntax.new('ruby/2.2.0')).to eq  Regexp::Syntax::V2_2_0 }
    it { expect(Regexp::Syntax.new('ruby/2.2.10')).to eq Regexp::Syntax::V2_2_0 }
    it { expect(Regexp::Syntax.new('ruby/2.2')).to eq    Regexp::Syntax::V2_2_0 }
    it { expect(Regexp::Syntax.new('ruby/2.3.0')).to eq  Regexp::Syntax::V2_3_0 }
    it { expect(Regexp::Syntax.new('ruby/2.3')).to eq    Regexp::Syntax::V2_3_0 }
    it { expect(Regexp::Syntax.new('ruby/2.4.0')).to eq  Regexp::Syntax::V2_4_0 }
    it { expect(Regexp::Syntax.new('ruby/2.4.1')).to eq  Regexp::Syntax::V2_4_1 }
    it { expect(Regexp::Syntax.new('ruby/2.5.0')).to eq  Regexp::Syntax::V2_5_0 }
    it { expect(Regexp::Syntax.new('ruby/2.5')).to eq    Regexp::Syntax::V2_5_0 }
    it { expect(Regexp::Syntax.new('ruby/2.6.0')).to eq  Regexp::Syntax::V2_6_0 }
    it { expect(Regexp::Syntax.new('ruby/2.6.2')).to eq  Regexp::Syntax::V2_6_2 }
    it { expect(Regexp::Syntax.new('ruby/2.6.3')).to eq  Regexp::Syntax::V2_6_3 }
    it { expect(Regexp::Syntax.new('ruby/2.6')).to eq    Regexp::Syntax::V2_6_3 }
    it { expect(Regexp::Syntax.new('ruby/3.0.0')).to eq  Regexp::Syntax::V2_6_3 }
    it { expect(Regexp::Syntax.new('ruby/3.0')).to eq    Regexp::Syntax::V2_6_3 }
    it { expect(Regexp::Syntax.new('ruby/3.1.0')).to eq  Regexp::Syntax::V3_1_0 }
    it { expect(Regexp::Syntax.new('ruby/3.1')).to eq    Regexp::Syntax::V3_1_0 }

    it { expect(Regexp::Syntax.new('any')).to eq         Regexp::Syntax::Any }
    it { expect(Regexp::Syntax.new('*')).to eq           Regexp::Syntax::Any }

    it 'warns for future versions' do
      expect { Regexp::Syntax.new('ruby/5.0') }.to output(/This library .* but you are running .*/).to_stderr
    end

    it 'raises for unknown names' do
      expect { Regexp::Syntax.new('ruby/1.0') }.to raise_error(Regexp::Syntax::UnknownSyntaxNameError)
    end

    it 'raises for invalid names' do
      expect { Regexp::Syntax.version_class('2.0.0') }.to raise_error(Regexp::Syntax::InvalidVersionNameError)
      expect { Regexp::Syntax.version_class('ruby/20') }.to raise_error(Regexp::Syntax::InvalidVersionNameError)
    end
  end

  specify('not implemented') do
    expect { RP.parse('\\p{alpha}', 'ruby/1.8') }.to raise_error(Regexp::Syntax::NotImplementedError)
  end

  specify('supported?') do
    expect(Regexp::Syntax.supported?('ruby/1.1.1')).to be false
    expect(Regexp::Syntax.supported?('ruby/2.4.3')).to be true
    expect(Regexp::Syntax.supported?('ruby/2.5')).to be true
  end

  specify('raises for unknown constant lookups') do
    expect { Regexp::Syntax::V1 }.to raise_error(/V1/)
  end

  specify('instantiation is deprecated but still works') do
    expect { @instance = Regexp::Syntax::V3_1_0.new }
      .to output(/deprecated/).to_stderr
    expect { expect(@instance.implements?(:literal, :literal)).to be true }
      .to output(/deprecated/).to_stderr
  end
end
