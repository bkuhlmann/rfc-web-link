# frozen_string_literal: true

require "spec_helper"

RSpec.describe RFC::Web::Link::Models::Value do
  subject(:model) { described_class[text: "test"] }

  describe "#initialize" do
    it "answers defaults" do
      expect(described_class[text: "test"]).to eq(
        described_class[encoding: "UTF-8", language: "en", text: "test"]
      )
    end
  end

  describe "#encode" do
    it "answers plain text without special characters" do
      expect(model.encode).to eq("UTF-8'en'test")
    end

    it "answers encoded text with special characters" do
      model = described_class[text: "£ and € rates"]
      expect(model.encode).to eq("UTF-8'en'%C2%A3%20and%20%E2%82%AC%20rates")
    end
  end
end
