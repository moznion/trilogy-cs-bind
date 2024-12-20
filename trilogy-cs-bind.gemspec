# frozen_string_literal: true

require_relative "lib/trilogy/cs/bind/version"

Gem::Specification.new do |spec|
  spec.name = "trilogy-cs-bind"
  spec.version = Trilogy::Cs::Bind::VERSION
  spec.authors = ["moznion"]
  spec.email = ["moznion@mail.moznion.net"]

  spec.summary = "An expansion library for Trilogy to support client-side binding."
  spec.description = "An expansion library for Trilogy to support client-side binding."
  spec.homepage = "https://github.com/moznion/trilogy-cs-bind"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/moznion/trilogy-cs-bind/blob/main/CHANGELOG.md"

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.metadata["rubygems_mfa_required"] = "true"
end
