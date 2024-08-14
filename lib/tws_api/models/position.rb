# frozen_string_literal: true

module TwsApi
  module Models
    # The Position class represents a financial position in trading terms, holding data about a certain contract,
    # the amount of the asset in the position, and the average cost at which the position was obtained.
    class Position
      attr_accessor :contract, :amount, :avg_cost

      def initialize(contract:, amount:, avg_cost:)
        @contract = contract
        @amount = amount
        @avg_cost = avg_cost
      end

      def ==(other)
        contract.conid == other.contract.conid && amount == other.amount && avg_cost == other.avg_cost
      end
    end
  end
end
