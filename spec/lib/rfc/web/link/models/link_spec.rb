# frozen_string_literal: true

require "spec_helper"

RSpec.describe RFC::Web::Link::Models::Link do
  subject :model do
    described_class[
      uri: "https://test.io",
      anchor: "#test",
      language: "en",
      media: "print",
      relation: "test",
      title: "Test",
      type: "text/plain"
    ]
  end

  describe "#to_s" do
    it "answers URI with all attributes" do
      expect(model.to_s).to eq(
        "<https://test.io>; anchor=#test; hreflang=en; media=print; " \
        "rel=test; title=Test; type=text/plain"
      )
    end

    it "answers URI and relation only" do
      model = described_class[uri: "https://test.io", relation: "test"]
      expect(model.to_s).to eq("<https://test.io>; rel=test")
    end

    it "answers quoted anchor" do
      model = described_class[uri: "https://test.io", relation: "test", anchor: %("#one,two,three")]
      expect(model.to_s).to eq(%(<https://test.io>; anchor="#one,two,three"; rel=test))
    end
  end
end
