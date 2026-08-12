# frozen_string_literal: true

require "spec_helper"

RSpec.describe RFC::Web::Link::Decoder do
  subject(:decoder) { described_class.new }

  describe "#call" do
    it "answers string for character set, language, and value" do
      expect(decoder.call("UTF-8'de'letztes%20K%C3%A4pitel")).to eq(
        RFC::Web::Link::Models::Value[text: "letztes Käpitel", language: "de"]
      )
    end

    it "answers string for character set and value but missing language" do
      expect(decoder.call("UTF-8''%c2%a3%20and%20%e2%82%ac%20rates")).to eq(
        RFC::Web::Link::Models::Value[text: "£ and € rates", language: ""]
      )
    end
  end
end
