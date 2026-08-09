# frozen_string_literal: true

require "spec_helper"

RSpec.describe RFC::Web::Link::Parsers::List do
  subject(:parser) { described_class.new }

  describe "#call" do
    let(:root_uri) { "https://test.io" }

    it "clears list before parsing" do
      parser.call("</articles>; rel=start", root_uri:)

      expect(parser.call("</articles>; rel=stop", root_uri:)).to eq(
        RFC::Web::Link::Models::List[
          links: Set[
            RFC::Web::Link::Models::Link[
              uri: "https://test.io/articles",
              pairs: Set[RFC::Web::Link::Models::Pair[key: :rel, value: "stop"]]
            ]
          ]
        ]
      )
    end

    it "answers record" do
      expect(parser.call("</articles>; rel=index", root_uri:)).to eq(
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

    it "answers record with comma delimited anchor" do
      text = %(</articles>; anchor="#one,two,three")

      expect(parser.call(text, root_uri:)).to eq(
        RFC::Web::Link::Models::List[
          links: Set[
            RFC::Web::Link::Models::Link[
              uri: "https://test.io/articles",
              pairs: Set[RFC::Web::Link::Models::Pair[key: :anchor, value: %("#one,two,three")]]
            ]
          ]
        ]
      )
    end

    it "answers multiple records with no spaces between delimiter" do
      text = "</articles?page=1>; rel=previous,</articles?page=3>; rel=next"

      expect(parser.call(text, root_uri:)).to eq(
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

    it "answers multiple records" do
      text = "</articles?page=1>; rel=previous, </articles?page=3>; rel=next"

      expect(parser.call(text, root_uri:)).to eq(
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

    it "answers multiple records for relation with multiple values" do
      text = %(<https://test.io>; rel="start end")

      expect(parser.call(text, root_uri:)).to eq(
        RFC::Web::Link::Models::List[
          links: Set[
            RFC::Web::Link::Models::Link[
              uri: "https://test.io",
              pairs: Set[RFC::Web::Link::Models::Pair[key: :rel, value: "start"]]
            ],
            RFC::Web::Link::Models::Link[
              uri: "https://test.io",
              pairs: Set[RFC::Web::Link::Models::Pair[key: :rel, value: "end"]]
            ]
          ]
        ]
      )
    end

    it "answers empty list when link doesn't start with less than character" do
      expect(parser.call("/articles>; rel=index", root_uri:)).to eq(
        RFC::Web::Link::Models::List.new
      )
    end

    it "answers empty list for nil" do
      expect(parser.call(nil, root_uri:)).to eq(RFC::Web::Link::Models::List.new)
    end

    it "answers empty list for blank string" do
      expect(parser.call("", root_uri:)).to eq(RFC::Web::Link::Models::List.new)
    end
  end
end
