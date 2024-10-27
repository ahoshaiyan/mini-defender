# frozen_string_literal: true

require_relative "lib/mini_defender/version"

Gem::Specification.new do |spec|
  spec.name = "mini_defender"
  spec.version = MiniDefender::VERSION
  spec.authors = ["Ali Alhoshaiyan"]
  spec.email = ["ahoshaiyan@fastmail.com"]

  spec.summary = "A small and efficient validation library for Rails and anything that uses Ruby."
  spec.description = spec.summary
  spec.homepage = "https://github.com/ahoshaiyan/mini-defender"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'activesupport', '>= 6.0'
  spec.add_runtime_dependency 'activemodel', '>= 6.0'
  spec.add_runtime_dependency 'actionpack', '>= 6.0'
  spec.add_runtime_dependency 'countries'
  spec.add_runtime_dependency 'money'
  spec.add_runtime_dependency 'marcel'
end
