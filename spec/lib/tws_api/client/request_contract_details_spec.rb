# frozen_string_literal: true

require 'spec_helper'
require 'logger'

RSpec.describe TwsApi::Client, '#request_contract_details', :tcp_proxy do
  let(:client) { described_class.new(logger:) }
  let(:logger) { Logger.new($stderr) }

  around do |example|
    client.connect(port: 9999, client_id: 1)
    sleep 0.5

    example.call
    client.disconnect
  end

  it 'returns ContractDetails object', :aggregate_failures do
    estx = TwsApi::Models::Index.stoxx50

    details = client.request_contract_details(estx)
    expect(details.contract.conid).to eq(estx.conid)
  end
end
