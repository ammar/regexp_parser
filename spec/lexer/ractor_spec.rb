# frozen_string_literal: true

require 'spec_helper'

RSpec.describe('Lexing outside the main Ractor') do
  it "lexes outside the main Ractor" do
    r = regexp_with_all_features
    works_on_ractor(r) { |r| RL.lex(r) }
  end
end
