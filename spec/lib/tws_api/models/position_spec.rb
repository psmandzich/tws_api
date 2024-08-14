# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TwsApi::Models::Position do
  subject(:position) { described_class.new(contract:, amount: 100, avg_cost: 50.0) }

  let(:contract) { TwsApi::Models::Contract.build(conid: 123) }

  describe '#==' do
    it 'is expected to be equal' do
      expect(position).to eq(described_class.new(contract: TwsApi::Models::Contract.build(conid: 123),
                                                 amount: 100,
                                                 avg_cost: 50.0))
    end

    context 'when contract is a Java::ComIbClient::Contract' do
      let(:contract) do
        contract = Java::ComIbClient::Contract.new
        contract.conid(123)
        contract
      end

      it 'is expected to be equal for same conid' do
        expect(position).to eq(described_class.new(contract: TwsApi::Models::Contract.build(conid: 123),
                                                   amount: 100,
                                                   avg_cost: 50.0))
      end
    end

    context 'when positions conid differs' do
      it 'is expected to be inequal' do
        expect(position).not_to eq(described_class.new(contract: TwsApi::Models::Contract.build(conid: 234),
                                                       amount: 100,
                                                       avg_cost: 50.0))
      end
    end

    context 'when positions amount differs' do
      it 'is expected to be inequal' do
        expect(position).not_to eq(described_class.new(contract: TwsApi::Models::Contract.build(conid: 123),
                                                       amount: 200,
                                                       avg_cost: 50.0))
      end
    end

    context 'when positions avg_cost differs' do
      it 'is expected to be inequal' do
        expect(position).not_to eq(described_class.new(contract: TwsApi::Models::Contract.build(conid: 123),
                                                       amount: 100,
                                                       avg_cost: 25.0))
      end
    end
  end
end
