# frozen_string_literal: true

require 'spec_helper'
require 'logger'

RSpec.describe TwsApi::Client, '#request_options_chain', tcp_proxy: { record: :once } do
  let(:client) { described_class.new(logger:) }
  let(:logger) { Logger.new($stderr) }

  around do |example|
    client.connect(port: 9999, client_id: 1)
    sleep 0.5

    example.call
    client.disconnect
  end

  it 'stores chain information within contract', :aggregate_failures do
    estx = TwsApi::Models::Index.stoxx50
    expect(estx.option_chain).to be_nil

    client.request_options_chain(estx)
    expect(estx.option_chain).to be_a(TwsApi::Models::OptionChain)

    definitions = estx.option_chain.instance_variable_get(:@definitions)
    expect(definitions.count).to eq(2)
    expect(definitions[0]).to include(
      exchange: 'EUREX',
      strikes: be_a(Array),
      expirations: be_a(Array),
      multiplier: '10',
      trading_class: 'OESX'
    )
    expect(definitions[1]).to include(
      exchange: 'EUREX',
      strikes: be_a(Array),
      expirations: be_a(Array),
      multiplier: '10',
      trading_class: 'OEXP'
    )
  end
end
