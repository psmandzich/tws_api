# frozen_string_literal: true

module TwsApi
  module ClientMixins
    # Defines methods for handling option chain in the Trader Workstation (TWS) system.
    module OptionChain
      # Initiates a request to the external TWS API to fetch option chains based on the specified contract details.
      # The method synchronously waits until the complete option chain definition is received from the API.
      # Once the data is obtained, it enriches the passed contract object with the received options chain information.
      # If the data is not received, it returns nil.
      #
      # @param contract [Contract] A contract object containing essential details such as symbol, sec_type, and conid.
      # @return [Hash, nil] The options chain data for the specified contract, or nil if there is a failure in data
      #                     reception or processing.
      def request_options_chain(contract)
        req_id = next_valid_id
        @request_data.init_request(req_id, contract)
        client.req_sec_def_opt_params(req_id, contract.symbol, '', contract.sec_type.to_s, contract.conid)

        return unless @request_data.wait_for_data(req_id)

        contract = @request_data.access_object(req_id)
        defintiion = @request_data.get_data(req_id)
        contract.option_chain = Models::OptionChain.new(defintiion)
      end

      private

      # Processes individual parameter data received from TWS during an options chain request.
      #
      # @param req_id [Integer] the identification of the request.
      # @param exchange [String] the exchange on which options are traded.
      # @param _underlying_con_id [NilClass] (Unused) Underlying contract identifier.
      # @param trading_class [String] the trading class associated with the options.
      # @param multiplier [String] the multiplier for the options contracts.
      # @param expirations [Array] a list of expiration dates for the options.
      # @param strikes [Array] a list of strike prices available.
      def security_definition_optional_parameter(req_id, exchange, _underlying_con_id, trading_class, multiplier, # rubocop:disable Metrics/ParameterLists
                                                 expirations, strikes)
        data = {
          exchange:,
          expirations: expirations.to_a.map { |expiration| Time.strptime(expiration, '%Y%m%d').to_date }.sort,
          strikes: strikes.to_a.sort,
          multiplier:,
          trading_class:
        }
        @request_data.append_data(req_id, data)
      end

      # Finalizes the construction of the option chain for a request after all parameter data has been processed.
      #
      # @param req_id [Integer] the request identification number.
      def security_definition_optional_parameter_end(req_id)
        @request_data.ready!(req_id)
      end
    end
  end
end
