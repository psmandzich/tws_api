# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext/numeric/time'
require 'active_support/core_ext/time/calculations'
require 'zeitwerk'
require_relative 'tws_api/version'

loader = Zeitwerk::Loader.for_gem
loader.setup

module TwsApi # rubocop:disable Style/Documentation
end
