# frozen_string_literal: true

module TwsApi
  module ClientMixins
    # Defines methods to retrieve positions in the Trader Workstation (TWS) system.
    module Positions
      # Subscribes to position updates for all accessible accounts. All positions sent initially, and then only updates
      # as positions change.
      def request_positions
        client.req_positions
      end

      # Cancels a previous position subscription request made with request_positions
      def cancel_positions
        client.cancel_positions
      end

      # Requests position subscription for account and/or model Initially all positions are returned, and then updates
      # are returned for any position changes in real time.
      def request_filtered_positions(account: '', model_code: '')
        req_id = next_request_id
        @request_data.init_request(req_id, { account:, model_code: })
        client.req_positions_multi(req_id, account, model_code)

        return unless @request_data.wait_for_data(req_id)

        client.cancel_positions_multi(req_id)
        @request_data.get_data(req_id)
      end

      private

      def position(account, contract, pos, avg_cost)
        connected_accounts.find { |c_account| c_account.id == account }
                          .positions.push(TwsApi::Models::Position.new(
                                            contract:,
                                            amount: pos,
                                            avg_cost:
                                          ))
        logger.debug("position Account='#{account}' Contract='#{contract}' Pos='#{pos}' AvgCost='#{avg_cost}'")
      end

      def position_end
        logger.debug('position_end')
      end

      def position_multi(req_id, account, model_code, contract, pos, avg_cost) # rubocop:disable Metrics/ParameterLists
        @request_data.append_data(req_id, TwsApi::Models::Position.new(contract:, amount: pos, avg_cost:))

        logger.debug("position_multi ReqId='#{req_id}' Account='#{account}' ModelCode='#{model_code}' " \
                     "Contract='#{contract}' Pos='#{pos}' AvgCost='#{avg_cost}'")
      end

      def position_multi_end(req_id)
        @request_data.ready!(req_id)
        logger.debug("position_multi_end ReqId='#{req_id}'")
      end
    end
  end
end
