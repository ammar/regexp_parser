require 'spec_helper'

RSpec.describe(Regexp::Syntax::V3_2_0) do
  include_examples 'syntax',
  implements: {
    property: T::Property::Script_V3_2_0 + T::Property::Age_V3_2_0,
    nonproperty: T::Property::Script_V3_2_0 + T::Property::Age_V3_2_0
  }
end
