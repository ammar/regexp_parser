# frozen_string_literal: true

require 'spec_helper'

RSpec.describe(Regexp::Syntax::V3_2_0) do
  include_examples 'syntax',
  implements: {
    property: T::UnicodeProperty::Script_V3_2_0 + T::UnicodeProperty::Age_V3_2_0,
    nonproperty: T::UnicodeProperty::Script_V3_2_0 + T::UnicodeProperty::Age_V3_2_0
  }
end
