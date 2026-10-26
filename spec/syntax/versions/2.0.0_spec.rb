# frozen_string_literal: true

require 'spec_helper'

RSpec.describe(Regexp::Syntax::V2_0_0) do
  include_examples 'syntax',
  implements: {
    property: T::UnicodeProperty::Age_V2_0_0,
    nonproperty: T::UnicodeProperty::Age_V2_0_0
  }

  unless RUBY_ENGINE == 'jruby' # jruby never removed the newline property
    include_examples 'syntax',
    excludes: {
      property: %i[newline],
      nonproperty: %i[newline]
    }
  end
end
