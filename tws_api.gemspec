# frozen_string_literal: true

require_relative 'lib/tws_api/version'

Gem::Specification.new do |spec|
  spec.name = 'tws_api'
  spec.platform = 'java'
  spec.version = TwsApi::VERSION
  spec.authors = ['Patrick Smandzich']
  spec.email = ['psmandzich@users.noreply.github.com']

  spec.summary = "Wrapper around IBs' TWS API"
  spec.required_ruby_version = { # rubocop:disable Gemspec/RequiredRubyVersion
    jruby: '>= 9.4.8.0'
  }

  spec.files = Dir['lib/**/*.rb'] + Dir['jar/*.jar']
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'activesupport'
  spec.add_runtime_dependency 'zeitwerk'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
