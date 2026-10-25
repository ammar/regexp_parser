# frozen_string_literal: true

require 'spec_helper'

RSpec.describe('Parsing outside the main Ractor') do
  it "parses outside the main Ractor" do
    r = regexp_with_all_features
    works_on_ractor(r) { |r| RP.parse(r) }
  end
end
