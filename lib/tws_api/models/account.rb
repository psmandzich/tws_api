# frozen_string_literal: true

module TwsApi
  module Models
    # This class represents an account in the system.
    class Account
      attr_accessor :id

      def initialize(id:)
        @id = id
      end
    end
  end
end
