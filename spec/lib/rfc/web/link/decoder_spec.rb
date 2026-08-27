# frozen_string_literal: true

require "spec_helper"

RSpec.describe RFC::Web::Link::Decoder do
  subject(:decoder) { described_class.new }

  describe "#call" do
    it "answers hash with value, encoding, and language" do
      expect(decoder.call("UTF-8'de'letztes%20K%C3%A4pitel")).to eq(
        value: "letztes Käpitel",
        encoding: "UTF-8",
        language: "de"
      )
    end

    it "answers hash with value, encoding, and blank language" do
      expect(decoder.call("UTF-8''%C2%A3%20and%20%E2%82%AC%20rates")).to eq(
        value: "£ and € rates",
        encoding: "UTF-8",
        language: ""
      )
    end

    it "answers hash with nils for value with invalid byte sequence" do
      expect(decoder.call("UTF-8'en'\xFF\xFF")).to eq(value: nil, encoding: nil, language: nil)
    end

    it "answers hash with value for quoted text" do
      expect(decoder.call(%("test"))).to eq(value: "test", encoding: nil, language: nil)
    end

    it "answers hash with value for plain text" do
      expect(decoder.call("test")).to eq(value: "test", encoding: nil, language: nil)
    end

    it "answers hash with nils for nil text" do
      expect(decoder.call(nil)).to eq(value: nil, encoding: nil, language: nil)
    end

    it "answers nil text for empty text" do
      expect(decoder.call("")).to eq(value: nil, encoding: nil, language: nil)
    end
  end
end
