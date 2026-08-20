# frozen_string_literal: true

require "spec_helper"

RSpec.describe RFC::Web::Link::Models::List do
  subject(:model) { described_class.new }

  let(:relation) { RFC::Web::Link::Models::Link[uri: "https://test.io"].append :rel, "index" }
  let(:title) { RFC::Web::Link::Models::Link[uri: "https://test.io"].append :title, "Test" }

  describe "#all?" do
    before { model.add relation }

    it "answers true all are true" do
      result = model.all? Data
      expect(result).to be(true)
    end

    it "answers false all are false" do
      result = model.all? Integer
      expect(result).to be(false)
    end
  end

  describe "#any?" do
    before { model.add relation }

    it "answers true some are true" do
      result = model.any? Data
      expect(result).to be(true)
    end

    it "answers false when none are true" do
      result = model.any? Integer
      expect(result).to be(false)
    end
  end

  describe "#empty?" do
    it "answers true when empty" do
      expect(model.empty?).to be(true)
    end

    it "answers false when filled" do
      model.add relation
      expect(model.empty?).to be(false)
    end
  end

  describe "#find" do
    it "answers link when found" do
      model.add relation
      result = model.find { it.uri == "https://test.io" }

      expect(result).to eq(relation)
    end

    it "answers nil when not found" do
      result = model.find { it.uri == "https://test.io" }
      expect(result).to be(nil)
    end
  end

  describe "#include?" do
    it "answers true when link is included" do
      model.add relation
      expect(model.include?(relation)).to be(true)
    end

    it "answers false when link isn't included" do
      expect(model.include?(relation)).to be(false)
    end
  end

  describe "#map" do
    it "maps over each link" do
      model.add(relation).add title
      links = model.map { "link: #{it}" }

      expect(links).to eq(
        [
          "link: <https://test.io>; rel=index",
          "link: <https://test.io>; title=Test"
        ]
      )
    end
  end

  describe "#none?" do
    it "answers true without links" do
      expect(model.none?).to be(true)
    end

    it "answers false with links" do
      model.add relation
      expect(model.none?).to be(false)
    end
  end

  describe "#one?" do
    it "answers true with one link" do
      model.add relation
      expect(model.one?).to be(true)
    end

    it "answers false with no links" do
      expect(model.one?).to be(false)
    end
  end

  describe "#size" do
    it "answers zero with no links" do
      expect(model.size).to eq(0)
    end

    it "answers positive integer with links" do
      model.add relation
      expect(model.size).to eq(1)
    end
  end

  describe "#add" do
    it "adds link" do
      model.add relation
      expect(model).to eq(described_class[links: Set[relation]])
    end

    it "ignores duplicates" do
      model.add(relation).add(relation)
      expect(model).to eq(described_class[links: Set[relation]])
    end

    it "answers itself" do
      expect(model.add(relation)).to eq(described_class[links: Set[relation]])
    end
  end

  describe "#clear" do
    it "clears all links" do
      model.add relation
      model.clear

      expect(model.empty?).to be(true)
    end

    it "answers itself" do
      expect(model.clear).to eq(described_class.new)
    end
  end

  describe "#each" do
    it "enumerates over each link" do
      model.add(relation).add title
      buffer = +""

      model.each { buffer << "#{it} " }

      expect(buffer).to eq("<https://test.io>; rel=index <https://test.io>; title=Test ")
    end

    it "answers itself when not given a block" do
      expect(model.each).to eq(model)
    end
  end

  describe "#reject" do
    before { model.add(relation).add title }

    it "answers updated instance without rejects" do
      update = model.reject { it.to_s.include? "rel" }
      expect(update).to eq(described_class[links: Set[title]])
    end
  end

  describe "#select" do
    before { model.add(relation).add title }

    it "answers updated instance selections" do
      update = model.select { it.to_s.include? "rel" }
      expect(update).to eq(described_class[links: Set[relation]])
    end
  end

  shared_examples "a string" do |method|
    it "answers multiple links" do
      model.add(relation).add title

      expect(model.public_send(method)).to eq(
        "<https://test.io>; rel=index, <https://test.io>; title=Test"
      )
    end

    it "answer a single link" do
      model.add relation
      expect(model.public_send(method)).to eq("<https://test.io>; rel=index")
    end

    it "answer an empty string with no links" do
      expect(model.public_send(method)).to eq("")
    end
  end

  describe "#to_s" do
    it_behaves_like "a string", :to_s
  end

  describe "#to_str" do
    it_behaves_like "a string", :to_str
  end
end
