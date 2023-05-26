# zoksh.gemspec

Gem::Specification.new do |spec|
  spec.name          = "zoksh"
  spec.version       = "1.0.0"
  spec.authors       = ["Your Name"]
  spec.email         = ["your@email.com"]
  spec.summary       = "Zoksh - Ruby Gem for Lightning Network Integration"
  spec.description   = <<-DESC
    Zoksh is a Ruby gem that provides integration with the Lightning Network for asset transfer and cross-chain payments.
  DESC
  spec.homepage      = "https://github.com/your_username/zoksh"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*.rb"]

  spec.add_dependency "httparty", "~> 0.20.0"
  spec.add_dependency "json", "~> 2.5.1"

  spec.required_ruby_version = ">= 2.5"

  spec.metadata["source_code_uri"] = "https://github.com/your_username/zoksh"
  spec.metadata["bug_tracker_uri"] = "https://github.com/your_username/zoksh/issues"

  spec.test_files = Dir["spec/**/*"]

  spec.require_paths = ["lib"]
end
