# frozen_string_literal: true

require "spec_helper"

RSpec.describe RFC::Web::Link::Parsers::Line do
  subject(:parser) { described_class.new }

  describe "#call" do
    let(:root_uri) { "https://test.io" }

    it "answers record for attributes with no spaces between delimiter" do
      expect(parser.call("</test>;rel=index;anchor=#test", root_uri:)).to eq(
        RFC::Web::Link::Models::Link[
          uri: "https://test.io/test",
          pairs: Set[
            RFC::Web::Link::Models::Pair[key: :rel, value: "index"],
            RFC::Web::Link::Models::Pair[key: :anchor, value: "#test"]
          ]
        ]
      )
    end

    it "answers record with anchor" do
      expect(parser.call("</test>; anchor=#test", root_uri:)).to eq(
        RFC::Web::Link::Models::Link[
          uri: "https://test.io/test",
          pairs: Set[RFC::Web::Link::Models::Pair[key: :anchor, value: "#test"]]
        ]
      )
    end

    it "answers record with anchor (first only)" do
      expect(parser.call("</test>; anchor=#one; anchor=#two", root_uri:)).to eq(
        RFC::Web::Link::Models::Link[
          uri: "https://test.io/test",
          pairs: Set[RFC::Web::Link::Models::Pair[key: :anchor, value: "#one"]]
        ]
      )
    end

    it "answers record with anchor URI fully resolved" do
      expect(parser.call("</test>; anchor=/other", root_uri:)).to eq(
        RFC::Web::Link::Models::Link[
          uri: "https://test.io/test",
          pairs: Set[RFC::Web::Link::Models::Pair[key: :anchor, value: "https://test.io/other"]]
        ]
      )
    end

    it "answers record with single language" do
      expect(parser.call(%(</test>; hreflang=en), root_uri:)).to eq(
        RFC::Web::Link::Models::Link[
          uri: "https://test.io/test",
          pairs: Set[RFC::Web::Link::Models::Pair[key: :hreflang, value: "en"]]
        ]
      )
    end

    it "answers record with multiple languages" do
      expect(parser.call("</test>; hreflang=en; hreflang=de", root_uri:)).to eq(
        RFC::Web::Link::Models::Link[
          uri: "https://test.io/test",
          pairs: Set[
            RFC::Web::Link::Models::Pair[key: :hreflang, value: "en"],
            RFC::Web::Link::Models::Pair[key: :hreflang, value: "de"]
          ]
        ]
      )
    end

    it "answers record with media" do
      expect(parser.call("</test>; media=print", root_uri:)).to eq(
        RFC::Web::Link::Models::Link[
          uri: "https://test.io/test",
          pairs: Set[RFC::Web::Link::Models::Pair[key: :media, value: "print"]]
        ]
      )
    end

    it "answers record with media (first only)" do
      expect(parser.call("</test>; media=print; media=all", root_uri:)).to eq(
        RFC::Web::Link::Models::Link[
          uri: "https://test.io/test",
          pairs: Set[RFC::Web::Link::Models::Pair[key: :media, value: "print"]]
        ]
      )
    end

    it "answers record with relation (plain)" do
      expect(parser.call("</test>; rel=index", root_uri:)).to eq(
        RFC::Web::Link::Models::Link[
          uri: "https://test.io/test",
          pairs: Set[RFC::Web::Link::Models::Pair[key: :rel, value: "index"]]
        ]
      )
    end

    it "answers record with relation (quoted)" do
      expect(parser.call(%(</test>; rel="index"), root_uri:)).to eq(
        RFC::Web::Link::Models::Link[
          uri: "https://test.io/test",
          pairs: Set[RFC::Web::Link::Models::Pair[key: :rel, value: %("index")]]
        ]
      )
    end

    it "answers record with relation (first only)" do
      expect(parser.call(%(</test>; rel=start; rel=end), root_uri:)).to eq(
        RFC::Web::Link::Models::Link[
          uri: "https://test.io/test",
          pairs: Set[RFC::Web::Link::Models::Pair[key: :rel, value: "start"]]
        ]
      )
    end

    it "answers record with title" do
      expect(parser.call("</test>; title=test", root_uri:)).to eq(
        RFC::Web::Link::Models::Link[
          uri: "https://test.io/test",
          pairs: Set[RFC::Web::Link::Models::Pair[key: :title, value: "test"]]
        ]
      )
    end

    it "answers record with quoted title" do
      expect(parser.call(%(</test>; title="A test"), root_uri:)).to eq(
        RFC::Web::Link::Models::Link[
          uri: "https://test.io/test",
          pairs: Set[RFC::Web::Link::Models::Pair[key: :title, value: %("A test")]]
        ]
      )
    end

    it "answers record with title (first only)" do
      expect(parser.call("</test>; title=one; title=two", root_uri:)).to eq(
        RFC::Web::Link::Models::Link[
          uri: "https://test.io/test",
          pairs: Set[RFC::Web::Link::Models::Pair[key: :title, value: "one"]]
        ]
      )
    end

    it "answers record with decoded title and language" do
      text = "</test>; title*=UTF-8'de'letztes%20K%C3%A4pitel"

      expect(parser.call(text, root_uri:)).to eq(
        RFC::Web::Link::Models::Link[
          uri: "https://test.io/test",
          pairs: Set[
            RFC::Web::Link::Models::Pair[
              key: :title,
              delimiter: "*=",
              value: "letztes Käpitel",
              encoding: "UTF-8",
              language: "de"
            ]
          ]
        ]
      )
    end

    it "answers record with decoded title (encoded version wins)" do
      text = "</test>; title=test; title*=UTF-8'de'letztes%20K%C3%A4pitel"

      expect(parser.call(text, root_uri:)).to eq(
        RFC::Web::Link::Models::Link[
          uri: "https://test.io/test",
          pairs: Set[
            RFC::Web::Link::Models::Pair[
              key: :title,
              delimiter: "*=",
              value: "letztes Käpitel",
              encoding: "UTF-8",
              language: "de"
            ]
          ]
        ]
      )
    end

    it "answers record type" do
      expect(parser.call("</test>; type=text/html", root_uri:)).to eq(
        RFC::Web::Link::Models::Link[
          uri: "https://test.io/test",
          pairs: Set[RFC::Web::Link::Models::Pair[key: :type, value: "text/html"]]
        ]
      )
    end

    it "answers record type (first only)" do
      expect(parser.call("</test>; type=text/html; type=text/plain", root_uri:)).to eq(
        RFC::Web::Link::Models::Link[
          uri: "https://test.io/test",
          pairs: Set[RFC::Web::Link::Models::Pair[key: :type, value: "text/html"]]
        ]
      )
    end

    it "answers record extended attribute" do
      expect(parser.call(%(</test>; extra=test), root_uri:)).to eq(
        RFC::Web::Link::Models::Link[
          uri: "https://test.io/test",
          pairs: Set[RFC::Web::Link::Models::Pair[key: :extra, value: "test"]]
        ]
      )
    end

    it "answers record with decoded extended attribute (encoded version wins)" do
      text = "</test>; currency=EUR; currency*=UTF-8'de'%C2%A3"

      expect(parser.call(text, root_uri:)).to eq(
        RFC::Web::Link::Models::Link[
          uri: "https://test.io/test",
          pairs: Set[
            RFC::Web::Link::Models::Pair[
              key: :currency,
              delimiter: "*=",
              value: "£",
              encoding: "UTF-8",
              language: "de"
            ]
          ]
        ]
      )
    end
  end
end
