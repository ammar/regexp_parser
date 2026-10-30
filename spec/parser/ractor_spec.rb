# frozen_string_literal: true

require 'spec_helper'

Warning.ignore(/Ractor .* experimental/)

if defined?(Ractor) && !Ractor.method_defined?(:value)
  Ractor.define_method(:value) { take }
end

RSpec.describe(Regexp::Parser, if: defined?(Ractor) && ruby_version_at_least("3.2")) do
  it "works with Ractor" do
    ractor = Ractor.new(regexp_with_all_features) { |r| RP.parse(r) }
    value = ractor.value
    expect(value).to be_a RE::Root
  end

  it "can pass parse results to a Ractor" do
    ractor = Ractor.new(RP.parse(regexp_with_all_features)) { |r| r[0] }
    value = ractor.value
    expect(value).to be_a RE::WhiteSpace
  end

  [:dup, :clone].each do |copy_method|
    it "can handle #{copy_method} calls in a Ractor" do
      ractor = Ractor.new(regexp_with_all_features, copy_method) do |r, m|
        RP.parse(r).send(m)
      end
      value = ractor.value
      expect(value).to be_a RE::Root
    end

    it "can handle #{copy_method} results in a Ractor" do
      ractor = Ractor.new(RP.parse(regexp_with_all_features).send(copy_method)) do |r|
        r[0]
      end
      value = ractor.value
      expect(value).to be_a RE::WhiteSpace
    end
  end

  it "can handle recursive references in a Ractor" do
    ractor = Ractor.new { RP.parse(/foo\g<0>|bar/) }
    value = ractor.value
    expect(value.dig(0, 0, 1).to_s).to eq '\g<0>'
    expect(value.dig(0, 0, 1).referenced_expression.to_s).to eq 'foo\g<0>|bar'
  end

  it "can handle scan errors in a Ractor" do
    ractor = Ractor.new do
      Thread.current.report_on_exception = false # don't print error to stderr
      RP.parse('[a')
    end
    expect { ractor.value }.to raise_error do |err|
      expect(err.cause).to be_a RS::PrematureEndError
    end
  end
end
