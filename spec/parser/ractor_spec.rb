# frozen_string_literal: true

require 'spec_helper'

RSpec.describe(Regexp::Parser) do
  it "works with Ractor", if: defined?(Ractor) && Ractor.method_defined?(:value) do
    r = regexp_with_all_features
    ractor = Ractor.new(r) { |r| RP.parse(r) }
    expect(ractor.value).to be_a Regexp::Expression::Root
  end
end
