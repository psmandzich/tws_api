# frozen_string_literal: true

module TwsApi
  module Models
    # This class represents an Index derivative of a Contract
    class Index < Contract
      def initialize
        super
        sec_type 'IND'
      end

      # Constructs a new instance of Index representing the ASX AP index.
      # @return [Index] a preconfigured Index object for the ASX AP index.
      def self.asx
        contract = new
        contract.conid(8_406_411)
        contract.symbol('AP')
        contract.local_symbol('AP')
        contract.exchange('ASX')
        contract.currency('AUD')
        contract
      end

      # Constructs a new instance of Index representing the ASX XVI index.
      # @return [Index] a preconfigured Index object for the ASX XVI index.
      def self.vasx
        contract = new
        contract.conid(132_520_022)
        contract.symbol('XVI')
        contract.local_symbol('XVI')
        contract.exchange('ASX')
        contract.currency('AUD')
        contract
      end

      # Constructs a new instance of Index representing the CBOE SPX index.
      # @return [Index] a preconfigured Index object for the CBOE SPX index.
      def self.spx
        contract = new
        contract.conid(416_904)
        contract.symbol('SPX')
        contract.local_symbol('SPX')
        contract.exchange('CBOE')
        contract.currency('USD')
        contract
      end

      # Constructs a new instance of Index representing the CBOE VIX index.
      # @return [Index] a preconfigured Index object for the CBOE VIX index.
      def self.vix
        contract = new
        contract.conid(13_455_763)
        contract.symbol('VIX')
        contract.local_symbol('VIX')
        contract.exchange('CBOE')
        contract.currency('USD')
        contract
      end

      # Constructs a new instance of Index representing the HKFE HSI index.
      # @return [Index] a preconfigured Index object for the HKFE HSI index.
      def self.hsi
        contract = new
        contract.conid(1_328_298)
        contract.symbol('HSI')
        contract.local_symbol('HSI')
        contract.exchange('HKFE')
        contract.currency('HKD')
        contract
      end

      # Constructs a new instance of Index representing the HKFE VHSI index.
      # @return [Index] a preconfigured Index object for the HKFE VHSI index.
      def self.vhsi
        contract = new
        contract.conid(89_373_032)
        contract.symbol('VHSI')
        contract.local_symbol('VHSI')
        contract.exchange('HKFE')
        contract.currency('HKD')
        contract
      end

      # Constructs a new instance of Index representing the EUREX ESTX50 index.
      # @return [Index] a preconfigured Index object for the EUREX ESTX50 index.
      def self.stoxx50
        contract = new
        contract.conid(4_356_500)
        contract.symbol('ESTX50')
        contract.local_symbol('SX5E')
        contract.exchange('EUREX')
        contract.currency('EUR')
        contract
      end

      # Constructs a new instance of Index representing the EUREX VSTOXX index.
      # @return [Index] a preconfigured Index object for the EUREX VSTOXX index.
      def self.vstoxx
        contract = new
        contract.conid(35_913_933)
        contract.symbol('V2TX')
        contract.local_symbol('V2TX')
        contract.exchange('EUREX')
        contract.currency('EUR')
        contract
      end
    end
  end
end
