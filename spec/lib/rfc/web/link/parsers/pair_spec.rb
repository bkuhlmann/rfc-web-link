# frozen_string_literal: true

require "spec_helper"

RSpec.describe RFC::Web::Link::Parsers::Pair do
  subject(:parser) { described_class.new }

  describe "#call" do
    let(:root_uri) { "https://test.io" }

    it "answers anchor" do
      expect(parser.call("anchor=#test", root_uri:)).to eq(
        RFC::Web::Link::Models::Pair[key: :anchor, value: "#test"]
      )
    end

    it "answers anchor with expanded URI" do
      expect(parser.call("anchor=/other", root_uri:)).to eq(
        RFC::Web::Link::Models::Pair[key: :anchor, value: "https://test.io/other"]
      )
    end

    it "answers language" do
      expect(parser.call("hreflang=en", root_uri:)).to eq(
        RFC::Web::Link::Models::Pair[key: :hreflang, value: "en"]
      )
    end

    it "answers media" do
      expect(parser.call("media=print", root_uri:)).to eq(
        RFC::Web::Link::Models::Pair[key: :media, value: "print"]
      )
    end

    it "answers relation (plain)" do
      expect(parser.call("rel=index", root_uri:)).to eq(
        RFC::Web::Link::Models::Pair[key: :rel, value: "index"]
      )
    end

    it "answers relation (quoted)" do
      expect(parser.call(%(rel="index start"), root_uri:)).to eq(
        RFC::Web::Link::Models::Pair[key: :rel, value: %("index start")]
      )
    end

    it "answers title (plain)" do
      expect(parser.call("title=Test", root_uri:)).to eq(
        RFC::Web::Link::Models::Pair[key: :title, value: "Test"]
      )
    end

    it "answers title (quoted)" do
      expect(parser.call(%(title="A Test"), root_uri:)).to eq(
        RFC::Web::Link::Models::Pair[key: :title, value: %("A Test")]
      )
    end

    it "answers title (decoded)" do
      expect(parser.call("title*=UTF-8'de'letztes%20K%C3%A4pitel", root_uri:)).to eq(
        RFC::Web::Link::Models::Pair[
          key: :title,
          delimiter: "*=",
          value: "letztes Käpitel",
          encoding: "UTF-8",
          language: "de"
        ]
      )
    end

    it "answers type" do
      expect(parser.call("type=text/html", root_uri:)).to eq(
        RFC::Web::Link::Models::Pair[key: :type, value: "text/html"]
      )
    end

    it "answers extension (plain)" do
      expect(parser.call("extra=test", root_uri:)).to eq(
        RFC::Web::Link::Models::Pair[key: :extra, value: "test"]
      )
    end

    it "answers extension (decoded)" do
      expect(parser.call("currency*=UTF-8'de'%C2%A3", root_uri:)).to eq(
        RFC::Web::Link::Models::Pair[
          key: :currency,
          delimiter: "*=",
          value: "£",
          encoding: "UTF-8",
          language: "de"
        ]
      )
    end
  end

  describe "#inspect" do
    it "answers allowed instance variables" do
      expect(parser.inspect).to match(
        /@decoder=.+RFC::Web::Link::Decoder.+@model=RFC::Web::Link::Models::Pair/
      )
    end
  end
end
