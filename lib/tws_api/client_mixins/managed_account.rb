# frozen_string_literal: true

module TwsApi
  module ClientMixins
    # Defines methods for handling information of related accounts by a single account manager in
    # the Trader Workstation (TWS) system.
    module ManagedAccount
      # Requests a list of managed accounts from the TWS API.
      # Response is handled by `managed_accounts`
      #
      # @return [nil]
      def request_managed_accounts
        client.req_managed_accts
      end

      private

      # Processes the received string of managed accounts, splitting the list by commas
      # and creating new Account instances for each account ID. The accounts are then
      # stored in an instance variable for further use.
      #
      # @param accounts_list [String] A comma-separated string containing managed account identifiers.
      # @return [void]
      def managed_accounts(accounts_list)
        @connected_accounts = accounts_list.split(',').map do |id|
          TwsApi::Models::Account.new(id:)
        end
      end
    end
  end
end
