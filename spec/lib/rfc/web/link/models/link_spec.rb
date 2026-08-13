# frozen_string_literal: true

require "spec_helper"

RSpec.describe RFC::Web::Link::Models::Link do
  subject(:model) { described_class[uri: "https://test.io", relation: "index"] }

  describe "#add_extension" do
    subject(:model) { described_class[uri: "https://test.io", relation: "index"] }

    it "adds extension" do
      model.add_extension :test, "test"
      expect(model.extensions).to eq(test: "test")
    end

    it "answers itself" do
      expect(model.add_extension(:test, "test")).to eq(
        described_class[uri: "https://test.io", relation: "index", extensions: {test: "test"}]
      )
    end
  end

  describe "#extension?" do
    subject :model do
      described_class[uri: "https://test.io", relation: "index", extensions: {test: "test"}]
    end

    it "answers true when extension exists" do
      expect(model.extension?(:test)).to be(true)
    end

    it "answers false when extension doesn't exist" do
      expect(model.extension?(:bogus)).to be(false)
    end
  end

  describe "#to_h" do
    it "answers default attributes" do
      expect(model.to_h).to eq(uri: "https://test.io", relation: "index")
    end

    it "answers custom attributes" do
      model.add_extension(:one, 1).add_extension :two, 2
      expect(model.to_h).to eq(uri: "https://test.io", relation: "index", one: 1, two: 2)
    end
  end

  describe "#to_s" do
    subject :model do
      described_class[
        uri: "https://test.io",
        anchor: "#test",
        language: "en",
        media: "print",
        relation: "index",
        title: "Test",
        type: "text/plain"
      ]
    end

    it "answers URI with all attributes" do
      expect(model.to_s).to eq(
        "<https://test.io>; anchor=#test; hreflang=en; media=print; " \
        "rel=index; title=Test; type=text/plain"
      )
    end

    it "answers URI with all attributes and extensions" do
      model.add_extension(:one, 1).add_extension :two, 2

      expect(model.to_s).to eq(
        "<https://test.io>; anchor=#test; hreflang=en; media=print; " \
        "rel=index; title=Test; type=text/plain; one=1; two=2"
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
