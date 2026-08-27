# frozen_string_literal: true

require "spec_helper"

RSpec.describe RFC::Web::Link::Models::Link do
  subject(:model) { described_class[uri: "https://test.io"] }

  let(:pair) { RFC::Web::Link::Models::Pair[key: :relation, value: "index"] }

  describe "#empty?" do
    it "answers true when empty" do
      expect(model.empty?).to be(true)
    end

    it "answers false when filled" do
      model.add pair
      expect(model.empty?).to be(false)
    end
  end

  describe "#include?" do
    it "answers true when link is included" do
      model.add pair
      expect(model.include?(pair)).to be(true)
    end

    it "answers false when link isn't included" do
      expect(model.include?(pair)).to be(false)
    end
  end

  describe "#add" do
    it "adds pair" do
      model.add pair
      expect(model.pairs).to eq(Set[pair])
    end

    it "answers itself" do
      expect(model.add(pair)).to eq(described_class[uri: "https://test.io", pairs: Set[pair]])
    end
  end

  describe "#append" do
    it "adds pair" do
      model.append :relation, "index"
      expect(model.pairs).to eq(Set[pair])
    end

    it "answers itself" do
      expect(model.append(:relation, "index")).to eq(
        described_class[uri: "https://test.io", pairs: Set[pair]]
      )
    end
  end

  describe "#find_pair" do
    let(:title) { RFC::Web::Link::Models::Pair[key: :title, value: "Test"] }

    before { model.add(pair).add title }

    it "answers pair by single attribute" do
      expect(model.find_pair(key: "title")).to eq(title)
    end

    it "answers pair by single attribute (regular expression)" do
      expect(model.find_pair(value: /est/)).to eq(title)
    end

    it "answers pair by multiple attributes" do
      expect(model.find_pair(key: "title", delimiter: "=", value: "Test")).to eq(title)
    end

    it "answers nil when not found" do
      expect(model.find_pair(key: "bogus")).to be(nil)
    end
  end

  describe "#pair?" do
    subject(:model) { described_class[uri: "https://test.io", pairs: Set[pair]] }

    it "answers true when matched by single attribute (string)" do
      expect(model.pair?(key: "rel")).to be(true)
    end

    it "answers true when matched by single attribute (regular expression)" do
      expect(model.pair?(value: /in/)).to be(true)
    end

    it "answers true when matched by multiple attributes" do
      expect(model.pair?(key: "rel", delimiter: "=", value: "index")).to be(true)
    end

    it "answers false when pair can't be matched" do
      expect(model.pair?(key: "bogus")).to be(false)
    end
  end

  shared_examples "a string" do |method|
    subject :model do
      described_class[
        uri: "https://test.io",
        pairs: Set[
          RFC::Web::Link::Models::Pair[key: :anchor, value: "#test"],
          RFC::Web::Link::Models::Pair[key: :language, value: "en"],
          RFC::Web::Link::Models::Pair[key: :media, value: "print"],
          RFC::Web::Link::Models::Pair[key: :relation, value: "index"],
          RFC::Web::Link::Models::Pair[key: :title, value: "Test"],
          RFC::Web::Link::Models::Pair[key: :type, value: "text/plain"]
        ]
      ]
    end

    it "answers URI with all attributes" do
      expect(model.public_send(method)).to eq(
        "<https://test.io>; anchor=#test; hreflang=en; media=print; " \
        "rel=index; title=Test; type=text/plain"
      )
    end

    it "answers URI with all attributes and extensions" do
      model.append(:one, 1).append :two, 2

      expect(model.public_send(method)).to eq(
        "<https://test.io>; anchor=#test; hreflang=en; media=print; " \
        "rel=index; title=Test; type=text/plain; one=1; two=2"
      )
    end
  end

  describe "#to_s" do
    it_behaves_like "a string", :to_s
  end

  describe "#to_str" do
    it_behaves_like "a string", :to_str
  end
end
