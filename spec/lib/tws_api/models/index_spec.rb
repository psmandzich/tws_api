# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TwsApi::Models::Index do
  it 'initialize index with predefined secType', :aggregate_failures do
    instance = described_class.new
    expect(instance).to be_a(TwsApi::Models::Contract)
    expect(instance.sec_type).to eq(Java::ComIbClient::Types::SecType::IND)
  end

  it 'sucessfully initialize index AP' do
    expect(described_class.asx).to be_a(described_class)
  end

  it 'sucessfully initialize index XVI' do
    expect(described_class.vasx).to be_a(described_class)
  end

  it 'sucessfully initialize index SPX' do
    expect(described_class.spx).to be_a(described_class)
  end

  it 'sucessfully initialize index VIX' do
    expect(described_class.vix).to be_a(described_class)
  end

  it 'sucessfully initialize index HSI' do
    expect(described_class.hsi).to be_a(described_class)
  end

  it 'sucessfully initialize index VHSI' do
    expect(described_class.vhsi).to be_a(described_class)
  end

  it 'sucessfully initialize index ESTX50' do
    expect(described_class.stoxx50).to be_a(described_class)
  end

  it 'sucessfully initialize index V2TX' do
    expect(described_class.vstoxx).to be_a(described_class)
  end
end
