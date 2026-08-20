# frozen_string_literal: true

require "spec_helper"

RSpec.describe RFC::Web::Link::Models::Pair do
  subject(:model) { described_class[key: :title, value: "test"] }

  describe "#initialize" do
    it "answers defaults where key is cast as a string" do
      expect(described_class[key: :title, value: "test"]).to eq(
        described_class[key: "title", value: "test"]
      )
    end
  end

  describe "#encoded?" do
    it "answers true when delimiter has splat" do
      model = described_class[key: :title, delimiter: "*=", value: "test"]
      expect(model.encoded?).to be(true)
    end

    it "answers false when delimiter is equals" do
      model = described_class[key: :title, delimiter: "=", value: "test"]
      expect(model.encoded?).to be(false)
    end
  end

  shared_examples "a string" do |method|
    it "answers transformed relation key" do
      model = described_class[key: :relation, value: "test"]
      expect(model.public_send(method)).to eq("rel=test")
    end

    it "answers transformed language key" do
      model = described_class[key: :language, value: "en"]
      expect(model.public_send(method)).to eq("hreflang=en")
    end

    it "answers plain text without special characters" do
      expect(model.public_send(method)).to eq("title=test")
    end

    it "answers encoding, language, and text when present" do
      model = described_class[
        key: :title,
        delimiter: "*=",
        value: "€ rates",
        encoding: "UTF-8",
        language: "de"
      ]

      expect(model.public_send(method)).to eq("title*=UTF-8'de'%E2%82%AC%20rates")
    end

    it "answers encoded text with special characters" do
      model = described_class[
        key: :title,
        delimiter: "*=",
        value: "£ and € rates",
        encoding: "UTF-8"
      ]

      expect(model.public_send(method)).to eq("title*=UTF-8''%C2%A3%20and%20%E2%82%AC%20rates")
    end
  end

  describe "#to_s" do
    it_behaves_like "a string", :to_s
  end

  describe "#to_str" do
    it_behaves_like "a string", :to_str
  end
end
