# frozen_string_literal: true

require "spec_helper"

RSpec.describe RFC::Web::Link do
  subject(:link) { described_class.new "https://test.io" }

  describe ".new" do
    it "answers record for lowercase key" do
      headers = {"link" => "</articles>; rel=index"}

      expect(link.call(headers)).to eq(
        RFC::Web::Link::Models::List[
          links: Set[
            RFC::Web::Link::Models::Link[
              uri: "https://test.io/articles",
              pairs: Set[RFC::Web::Link::Models::Pair[key: :rel, value: "index"]]
            ]
          ]
        ]
      )
    end

    it "answers record for uppercase key" do
      headers = {"Link" => "</articles>; rel=index"}

      expect(link.call(headers)).to eq(
        RFC::Web::Link::Models::List[
          links: Set[
            RFC::Web::Link::Models::Link[
              uri: "https://test.io/articles",
              pairs: Set[RFC::Web::Link::Models::Pair[key: :rel, value: "index"]]
            ]
          ]
        ]
      )
    end

    it "answers records" do
      headers = {"Link" => "</articles?page=1>; rel=previous, </articles?page=3>; rel=next"}

      expect(link.call(headers)).to eq(
        RFC::Web::Link::Models::List[
          links: Set[
            RFC::Web::Link::Models::Link[
              uri: "https://test.io/articles?page=1",
              pairs: Set[RFC::Web::Link::Models::Pair[key: :rel, value: "previous"]]
            ],
            RFC::Web::Link::Models::Link[
              uri: "https://test.io/articles?page=3",
              pairs: Set[RFC::Web::Link::Models::Pair[key: :rel, value: "next"]]
            ]
          ]
        ]
      )
    end

    it "overrides root URI when supplied" do
      headers = {"link" => "</articles>; rel=index"}

      expect(link.call(headers, root_uri: "https://alt.io")).to eq(
        RFC::Web::Link::Models::List[
          links: Set[
            RFC::Web::Link::Models::Link[
              uri: "https://alt.io/articles",
              pairs: Set[RFC::Web::Link::Models::Pair[key: :rel, value: "index"]]
            ]
          ]
        ]
      )
    end

    it "answers empty array when header key isn't found" do
      expect(link.call({})).to eq(RFC::Web::Link::Models::List.new)
    end
  end
end
