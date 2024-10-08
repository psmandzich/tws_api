# frozen_string_literal: true

require 'spec_helper'
require 'logger'

RSpec.describe TwsApi::Client, '#request_filtered_positions', tcp_proxy: { record: :once } do
  let(:client) { described_class.new(logger:) }
  let(:logger) { Logger.new($stderr) }

  around do |example|
    client.connect(port: 9999, client_id: 1)
    sleep 0.5

    example.call
    client.disconnect
  end

  it 'requests unfiltered positions' do
    expect(client.request_filtered_positions).to include(
      TwsApi::Models::Position.new(
        contract: TwsApi::Models::Contract.build(conid: 498_843_743),
        amount: Java::ComIbClient::Decimal.get(-20.0),
        avg_cost: 165.13851
      ),
      TwsApi::Models::Position.new(
        contract: TwsApi::Models::Contract.build(conid: 10_749_447),
        amount: Java::ComIbClient::Decimal.get(-299.0),
        avg_cost: 39.70070235
      ),
      TwsApi::Models::Position.new(
        contract: TwsApi::Models::Contract.build(conid: 14_094),
        amount: Java::ComIbClient::Decimal.get(100),
        avg_cost: 111.8559
      ),
      TwsApi::Models::Position.new(
        contract: TwsApi::Models::Contract.build(conid: 265_598),
        amount: Java::ComIbClient::Decimal.get(100),
        avg_cost: 174.42
      )
    )
  end

  it 'requests positions filtered by account' do
    expect(client.request_filtered_positions(account: 'DU4328787')).to include(
      TwsApi::Models::Position.new(
        contract: TwsApi::Models::Contract.build(conid: 498_843_743),
        amount: Java::ComIbClient::Decimal.get(-20.0),
        avg_cost: 165.13851
      ),
      TwsApi::Models::Position.new(
        contract: TwsApi::Models::Contract.build(conid: 10_749_447),
        amount: Java::ComIbClient::Decimal.get(-299.0),
        avg_cost: 39.70070235
      ),
      TwsApi::Models::Position.new(
        contract: TwsApi::Models::Contract.build(conid: 14_094),
        amount: Java::ComIbClient::Decimal.get(100),
        avg_cost: 111.8559
      ),
      TwsApi::Models::Position.new(
        contract: TwsApi::Models::Contract.build(conid: 265_598),
        amount: Java::ComIbClient::Decimal.get(100),
        avg_cost: 174.42
      )
    )
  end

  it 'requests positions filtered by model_code', skip: 'create model_code in TWS first'
end
