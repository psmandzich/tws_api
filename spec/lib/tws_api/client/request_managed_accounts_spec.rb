# frozen_string_literal: true

require 'spec_helper'
require 'logger'

RSpec.describe TwsApi::Client, '#request_managed_accounts', tcp_proxy: { record: :once } do
  let(:client) { described_class.new(logger:) }
  let(:logger) { Logger.new($stderr) }

  around do |example|
    client.connect(port: 9999, client_id: 1)
    sleep 0.5

    example.call
    client.disconnect
  end

  it 'loads account information manually' do
    client.instance_variable_set :@connected_accounts, []

    client.request_managed_accounts
    sleep 0.5

    expect(client.connected_accounts).to be_any
  end
end
