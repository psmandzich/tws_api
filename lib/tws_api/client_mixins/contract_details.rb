# frozen_string_literal: true

module TwsApi
  module ClientMixins
    # Defines methods for handling contract details in the Trader Workstation (TWS) system.
    module ContractDetails
      # Requests detailed information about a specific contract from the server.
      # @param contract [Contract] The contract for which details are needed.
      # @return [ContractDetails] The first set of contract details received or nil if no data is received.
      def request_contract_details(contract)
        req_id = next_request_id
        request_data.init_request(req_id)
        client.req_contract_details(req_id, contract)

        return unless request_data.wait_for_data(req_id)

        request_data.get_data(req_id)[0]
      end

      private

      # Handles the incoming contract details response from the server.
      # @param req_id [Integer] The request identifier for tracking this specific request.
      # @param contract_details [Array<ContractDetails>] The details of the contract received.
      def contract_details(req_id, contract_details)
        request_data.append_data(req_id, contract_details)
        request_data.ready!(req_id)
      end

      # Signals the end of contract details delivery for a specific request.
      # @param req_id [Integer] The request ID marking the end of the contract details response.
      def contract_details_end(req_id)
        request_data.ready!(req_id)
      end
    end
  end
end
