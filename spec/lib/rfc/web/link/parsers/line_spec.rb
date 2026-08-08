# frozen_string_literal: true

require "spec_helper"

RSpec.describe RFC::Web::Link::Parsers::Line do
  subject(:parser) { described_class.new }

  describe "#call" do
    let(:root_uri) { "https://test.io" }

    it "answers record with URI and anchor" do
      expect(parser.call("</test>; rel=test; anchor=#test", root_uri:)).to eq(
        RFC::Web::Link::Models::Link[uri: "https://test.io/test", relation: "test", anchor: "#test"]
      )
    end

    it "answers record with URI and anchor (first only)" do
      expect(parser.call("</test>; rel=test; anchor=#one; anchor=#two", root_uri:)).to eq(
        RFC::Web::Link::Models::Link[uri: "https://test.io/test", relation: "test", anchor: "#one"]
      )
    end

    it "answers record with URI and anchor URI fully resolved" do
      expect(parser.call("</test>; rel=test; anchor=/other", root_uri:)).to eq(
        RFC::Web::Link::Models::Link[
          uri: "https://test.io/test",
          relation: "test",
          anchor: "https://test.io/other"
        ]
      )
    end

    it "answers record with URI and single language" do
      expect(parser.call(%(</test>; rel=test; hreflang="en"), root_uri:)).to eq(
        RFC::Web::Link::Models::Link[
          uri: "https://test.io/test",
          relation: "test",
          language: Set["en"]
        ]
      )
    end

    it "answers record with URI and multiple languages" do
      expect(parser.call("</test>; rel=test; hreflang=en; hreflang=de", root_uri:)).to eq(
        RFC::Web::Link::Models::Link[
          uri: "https://test.io/test",
          relation: "test",
          language: Set["en", "de"]
        ]
      )
    end

    it "answers record with URI and media" do
      expect(parser.call("</test>; rel=test; media=print", root_uri:)).to eq(
        RFC::Web::Link::Models::Link[uri: "https://test.io/test", relation: "test", media: "print"]
      )
    end

    it "answers record with URI and media (first only)" do
      expect(parser.call("</test>; rel=test; media=print; media=all", root_uri:)).to eq(
        RFC::Web::Link::Models::Link[uri: "https://test.io/test", relation: "test", media: "print"]
      )
    end

    it "answers record with URI and relation (plain)" do
      expect(parser.call("</test>; rel=start", root_uri:)).to eq(
        RFC::Web::Link::Models::Link[uri: "https://test.io/test", relation: "start"]
      )
    end

    it "answers record with URI and relation (quoted)" do
      expect(parser.call(%(</test>; rel="start"), root_uri:)).to eq(
        RFC::Web::Link::Models::Link[uri: "https://test.io/test", relation: "start"]
      )
    end

    it "answers record with URI and relation (first only)" do
      expect(parser.call(%(</test>; rel="start"; rel="end"), root_uri:)).to eq(
        RFC::Web::Link::Models::Link[uri: "https://test.io/test", relation: "start"]
      )
    end

    it "answers record with URI and title" do
      expect(parser.call("</test>; rel=test; title=test", root_uri:)).to eq(
        RFC::Web::Link::Models::Link[uri: "https://test.io/test", relation: "test", title: "test"]
      )
    end

    it "answers record with URI and title (first only)" do
      expect(parser.call("</test>; rel=test; title=one; title=two", root_uri:)).to eq(
        RFC::Web::Link::Models::Link[uri: "https://test.io/test", relation: "test", title: "one"]
      )
    end

    it "answers record with URI, decoded title, and language" do
      text = "</test>; rel=test; title*=UTF-8'de'letztes%20K%C3%A4pitel"

      expect(parser.call(text, root_uri:)).to eq(
        RFC::Web::Link::Models::Link[
          uri: "https://test.io/test",
          relation: "test",
          title: "letztes Käpitel"
        ]
      )
    end

    it "answers record with URI and decoded title (encoded version wins)" do
      text = "</test>; rel=test; title=test; title*=UTF-8'de'letztes%20K%C3%A4pitel"

      expect(parser.call(text, root_uri:)).to eq(
        RFC::Web::Link::Models::Link[
          uri: "https://test.io/test",
          relation: "test",
          title: "letztes Käpitel"
        ]
      )
    end

    it "answers record with URI and type" do
      expect(parser.call("</test>; rel=test; type=text/html", root_uri:)).to eq(
        RFC::Web::Link::Models::Link[
          uri: "https://test.io/test",
          relation: "test",
          type: "text/html"
        ]
      )
    end

    it "answers record with URI and type (first only)" do
      expect(parser.call("</test>; rel=test; type=text/html; type=text/plain", root_uri:)).to eq(
        RFC::Web::Link::Models::Link[
          uri: "https://test.io/test",
          relation: "test",
          type: "text/html"
        ]
      )
    end

    it "fails with invalid attribute" do
      expecation = proc { parser.call "</test>; bogus=danger", root_uri: }
      expect(&expecation).to raise_error(KeyError, /key not found/)
    end
  end
end
