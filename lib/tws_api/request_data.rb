# frozen_string_literal: true

module TwsApi
  # The RequestData class manages concurrent access to request-related data.
  # It serves to initialize requests, store and retrieve data associated with those requests, and handle their
  # synchronization. Thread safety is ensured using a Mutex to manage access to request data stored in a hash.
  class RequestData
    def initialize
      @requests = {}
      @mutex = Mutex.new
    end

    # Initializes a request with a given request ID (req_id) and an optional object.
    # It sets up a condition variable for threading synchronization.
    # @param req_id [Integer] the unique identifier for the request
    # @param object [Object] optional object associated with the request
    def init_request(req_id, object = nil)
      @mutex.synchronize do
        @requests[req_id] = {
          data: [],
          object:,
          event: ConditionVariable.new
        }
      end
    end

    # Appends data to a request identified by req_id.
    # @param req_id [Integer] the request identifier
    # @param data [Object] the data to append
    def append_data(req_id, data)
      @mutex.synchronize do
        @requests[req_id][:data] << data if @requests.key?(req_id)
      end
    end

    # Checks if the request identified by req_id is ready.
    # @param req_id [Integer] the request identifier
    # @return [Boolean] true if the request is ready, otherwise false
    def ready?(req_id)
      @mutex.synchronize do
        @requests[req_id][:event].nil?
      end
    end

    # Waits for data to be available in the request identified by req_id, with a specified timeout.
    # @param req_id [Integer] the request identifier
    # @param timeout [Integer] the number of seconds to wait before timing out (default is 10 seconds)
    def wait_for_data(req_id, timeout: 10)
      @mutex.synchronize do
        @requests[req_id][:event].wait(@mutex, timeout) if @requests.key?(req_id)
      end
    end

    # Gets access to the object associated with the request identified by req_id.
    # @param req_id [Integer] the request identifier
    # @return [Object] the object associated with the request
    def access_object(req_id)
      @mutex.synchronize do
        @requests[req_id][:object]
      end
    end

    # Finds request IDs that are associated with the specified object.
    # @param object [Object] the object to match request against
    # @return [Array<Integer>] the list of request ID's associated with the object
    def find_req_ids_by_object(object)
      @mutex.synchronize do
        @requests.select { |_req_id, details| details[:object] == object }.keys
      end
    end

    # Signals that the request identified by req_id is ready.
    # @param req_id [Integer] the request identifier
    def ready!(req_id)
      @mutex.synchronize do
        @requests[req_id][:event].signal if @requests.key?(req_id)
      end
    end

    # Retrieves the data for a request identified by req_id.
    # @param req_id [Integer] the request identifier
    # @return [Array<Object>] the data associated with the request
    def get_data(req_id)
      @mutex.synchronize do
        return unless @requests.key?(req_id)

        data = @requests[req_id][:data]
        @requests.delete(req_id)
        data
      end
    end
  end
end
