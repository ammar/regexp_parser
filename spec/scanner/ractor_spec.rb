# frozen_string_literal: true

require 'spec_helper'

RSpec.describe('Scanning outside the main Ractor') do
  it "scans outside the main Ractor" do
    r = regexp_with_all_features
    works_on_ractor(r) { |r| RS.scan(r) }
  end
end
