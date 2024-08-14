# frozen_string_literal: true

module TwsApi
  module Models
    # The Contract class serves as a Ruby-based wrapper that inherits from the Java class ComIbClient::Contract,
    # provided by the Interactive Brokers API through its Java interface. This class is part of a Ruby adaptation
    # intended to interface with the Interactive Brokers TWS (Trader Workstation) API. The main purpose of this
    # class is to provide an accessible, Ruby-feel abstraction, while maintaining the powerful capabilities and
    # functionalities of the native Java API.
    class Contract < Java::ComIbClient::Contract
      attr_accessor :option_chain
    end
  end
end
