require 'spec_helper'

RSpec.describe(Regexp::Syntax) do
  RSpec.shared_examples 'syntax alias' do |string, klass, version|
    it "aliases #{string} to #{klass} with feature version #{version}" do
      syntax = Regexp::Syntax.new(string)
      expect(syntax).to eq klass
      expect(syntax.feature_version).to eq version
    end
  end

  include_examples 'syntax alias', 'ruby/1.8.6',  Regexp::Syntax::V1_8_6,  Regexp::Syntax::V1_8_6
  include_examples 'syntax alias', 'ruby/1.8',    Regexp::Syntax::V1_8,    Regexp::Syntax::V1_8_6
  include_examples 'syntax alias', 'ruby/1.9.1',  Regexp::Syntax::V1_9_1,  Regexp::Syntax::V1_9_1
  include_examples 'syntax alias', 'ruby/1.9',    Regexp::Syntax::V1_9,    Regexp::Syntax::V1_9_3
  include_examples 'syntax alias', 'ruby/2.0.0',  Regexp::Syntax::V2_0_0,  Regexp::Syntax::V2_0_0
  include_examples 'syntax alias', 'ruby/2.0',    Regexp::Syntax::V2_0,    Regexp::Syntax::V2_0_0
  include_examples 'syntax alias', 'ruby/2.1',    Regexp::Syntax::V2_1,    Regexp::Syntax::V2_0_0
  include_examples 'syntax alias', 'ruby/2.2.0',  Regexp::Syntax::V2_2_0,  Regexp::Syntax::V2_2_0
  include_examples 'syntax alias', 'ruby/2.2.10', Regexp::Syntax::V2_2_10, Regexp::Syntax::V2_2_0
  include_examples 'syntax alias', 'ruby/2.2',    Regexp::Syntax::V2_2,    Regexp::Syntax::V2_2_0
  include_examples 'syntax alias', 'ruby/2.3.0',  Regexp::Syntax::V2_3_0,  Regexp::Syntax::V2_3_0
  include_examples 'syntax alias', 'ruby/2.3',    Regexp::Syntax::V2_3,    Regexp::Syntax::V2_3_0
  include_examples 'syntax alias', 'ruby/2.4.0',  Regexp::Syntax::V2_4_0,  Regexp::Syntax::V2_4_0
  include_examples 'syntax alias', 'ruby/2.4.1',  Regexp::Syntax::V2_4_1,  Regexp::Syntax::V2_4_1
  include_examples 'syntax alias', 'ruby/2.5.0',  Regexp::Syntax::V2_5_0,  Regexp::Syntax::V2_5_0
  include_examples 'syntax alias', 'ruby/2.5',    Regexp::Syntax::V2_5,    Regexp::Syntax::V2_5_0
  include_examples 'syntax alias', 'ruby/2.6.0',  Regexp::Syntax::V2_6_0,  Regexp::Syntax::V2_6_0
  include_examples 'syntax alias', 'ruby/2.6.2',  Regexp::Syntax::V2_6_2,  Regexp::Syntax::V2_6_2
  include_examples 'syntax alias', 'ruby/2.6.3',  Regexp::Syntax::V2_6_3,  Regexp::Syntax::V2_6_3
  include_examples 'syntax alias', 'ruby/2.6',    Regexp::Syntax::V2_6,    Regexp::Syntax::V2_6_3
  include_examples 'syntax alias', 'ruby/3.0.0',  Regexp::Syntax::V3_0_0,  Regexp::Syntax::V2_6_3
  include_examples 'syntax alias', 'ruby/3.0',    Regexp::Syntax::V3_0,    Regexp::Syntax::V2_6_3
  include_examples 'syntax alias', 'ruby/3.1.0',  Regexp::Syntax::V3_1_0,  Regexp::Syntax::V3_1_0
  include_examples 'syntax alias', 'ruby/3.1',    Regexp::Syntax::V3_1,    Regexp::Syntax::V3_1_0

  specify('future alias warning') do
    expect { Regexp::Syntax.new('ruby/5.0') }
      .to output(/This library .* but you are running .* \(feature set of .*\)/)
      .to_stderr
  end
end
