# frozen_string_literal: true

require 'spec_helper'

RSpec.describe(Regexp::Parser) do
  it "works with Ractor", if: defined?(Ractor) && ruby_version_at_least("3.2") do
    capturing_stderr do
      ractor = Ractor.new(regexp_with_all_features) { |r| RP.parse(r) }
      value = ractor.respond_to?(:value) ? ractor.value : ractor.take
      expect(value).to be_a Regexp::Expression::Root
    end
  end
end
