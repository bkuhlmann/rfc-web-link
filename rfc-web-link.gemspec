# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "rfc-web-link"
  spec.version = "0.0.0"
  spec.authors = ["Brooke Kuhlmann"]
  spec.email = ["brooke@alchemists.io"]
  spec.homepage = "https://alchemists.io/projects/rfc-web-link"
  spec.summary = "A RFC 8288 Web Linking implementation."
  spec.license = "Hippocratic-2.1"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/bkuhlmann/rfc-web-link/issues",
    "changelog_uri" => "https://alchemists.io/projects/rfc-web-link/versions",
    "homepage_uri" => "https://alchemists.io/projects/rfc-web-link",
    "funding_uri" => "https://github.com/sponsors/bkuhlmann",
    "label" => "RFC Web Link",
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "https://github.com/bkuhlmann/rfc-web-link"
  }

  spec.signing_key = Gem.default_key_path
  spec.cert_chain = [Gem.default_cert_path]

  spec.required_ruby_version = ">= 4.0"

  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.files = Dir["*.gemspec", "lib/**/*"]
end
