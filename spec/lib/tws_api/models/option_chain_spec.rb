# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TwsApi::Models::OptionChain do
  subject(:option_chain) do
    described_class.new(
      [
        { exchange: 'EUREX', expirations: [1.day.from_now.to_date, 3.days.from_now.to_date],
          strikes: [4950.0, 5000.0, 5050.0], multiplier: 10, trading_class: 'OESX' },
        { exchange: 'EUREX', expirations: [Date.today, 2.days.from_now.to_date],
          strikes: [4900.0, 5000.0, 5100.0], multiplier: 10, trading_class: 'OEXP' }
      ]
    )
  end

  describe '#find_expiration' do
    it 'returns first found of first definition' do
      expect(option_chain.find_expiration(0)).to eq(Date.tomorrow)
    end

    it 'returns nil for days after last expiry' do
      expect(option_chain.find_expiration(10)).to be_nil
    end

    it 'returns first found of OEXP definition' do
      expect(option_chain.find_expiration(0, trading_class: 'OEXP')).to eq(Date.today)
    end
  end

  describe '#find_strikes' do
    it 'returns strikes of first definition' do
      expect(option_chain.find_strikes).to eq([4950.0, 5000.0, 5050.0])
    end

    it 'returns strikes of requested trading_class' do
      expect(option_chain.find_strikes(trading_class: 'OEXP')).to eq([4900.0, 5000.0, 5100.0])
    end
  end
end
