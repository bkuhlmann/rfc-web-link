# frozen_string_literal: true

require "spec_helper"

RSpec.describe RFC::Web::Link::Parsers::List do
  subject(:parser) { described_class.new }

  describe "#call" do
    let(:root_uri) { "https://test.io" }

    it "answers single record" do
      text = "</articles>; rel=\"start\""

      expect(parser.call(text, root_uri:)).to eq(
        [RFC::Web::Link::Models::Link[uri: "https://test.io/articles", relation: "start"]]
      )
    end

    it "answers multiple records" do
      text = %(</articles?page=2>; rel="next", </articles?page=10>; rel="last")

      expect(parser.call(text, root_uri:)).to eq(
        [
          RFC::Web::Link::Models::Link[uri: "https://test.io/articles?page=2", relation: "next"],
          RFC::Web::Link::Models::Link[uri: "https://test.io/articles?page=10", relation: "last"]
        ]
      )
    end

    it "answers multiple records for relation with multiple values" do
      text = %(<https://test.io>; rel="start end")

      expect(parser.call(text, root_uri:)).to eq(
        [
          RFC::Web::Link::Models::Link[uri: "https://test.io", relation: "start"],
          RFC::Web::Link::Models::Link[uri: "https://test.io", relation: "end"]
        ]
      )
    end

    it "answers empty array for nil" do
      expect(parser.call(nil, root_uri:)).to eq([])
    end

    it "answers empty array for blank string" do
      expect(parser.call("", root_uri:)).to eq([])
    end
  end
end
