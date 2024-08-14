# frozen_string_literal: true

module TwsApi
  module Models
    # The OptionChain class provides the ability to parse through various options chain definitions,
    # allowing for retrieval of specific trading class information and option expiration details.
    # Each instance of OptionChain holds a collection of definitions which can be queried with specific criteria.
    class OptionChain
      attr_reader :definitions

      # Initializes a new instance of OptionChain with provided option chain definitions.
      # @param definitions [Array<Hash>] array containing option chain data.
      def initialize(definitions)
        @definitions = definitions
      end

      # Finds and returns the nearest expiration date available for an option, given a specific day.
      # Optionally allows filtering by a specific trading class.
      # @param day [Integer] the day from which we want to calculate nearest expiration.
      # @param trading_class [String, nil] the desired trading class to filter by (default: nil)
      # @return [Date] expiration date following the input day
      def find_expiration(day, trading_class: nil)
        expirations = find_definition(trading_class:)[:expirations]
        expirations.find { |expiration_date| expiration_date >= day.days.from_now.to_date }
      end

      # Retrieves all available strike prices for a given trading class.
      # If no trading class is specified, returns strikes for the first available definition.
      # @param trading_class [String, nil] the trading class to filter strikes by (default: nil)
      # @return [Array<Number>] an array of strike prices
      def find_strikes(trading_class: nil)
        find_definition(trading_class:)[:strikes]
      end

      private

      # Finds the definition from 'definitions' array that matches the specified trading class.
      # If no trading class is specified, returns the first definition available.
      # @param trading_class [String, nil] the trading class to locate (default: nil)
      # @return [Hash] the found definition hash.
      def find_definition(trading_class:)
        return definitions.first if trading_class.nil?

        definitions.find { |chain| chain[:trading_class] == trading_class }
      end
    end
  end
end
