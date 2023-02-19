require 'spec_helper'

RSpec.describe(Regexp::Syntax::V1_9_3) do
  include_examples 'syntax',
  implements: {
    property: T::Property::Script_V1_9_3 + T::Property::Age_V1_9_3,
    nonproperty: T::Property::Script_V1_9_3 + T::Property::Age_V1_9_3
  }
end
