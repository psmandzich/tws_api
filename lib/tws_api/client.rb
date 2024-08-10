# frozen_string_literal: true

require 'java'
require_relative '../../jar/TwsApi.jar'

module TwsApi
  # Class Client serves as the main interface for interaction with the Interactive Brokers API.
  # This class includes various mixins to handle different data domains such as contract details,
  # market data, option chains, and orders. Implements logging and handles connectivity and messaging
  # using the Java TwsApi API.
  class Client
    include Java::ComIbClient::EWrapper
    include ClientMixins::ManagedAccount

    attr_reader :logger, :connected_accounts, :client, :client_signal

    # Initializes a new instance of the Client class.
    #
    # @param logger [Logger] the logging object to be used for logging messages.
    #                         If none provided, it defaults to the default Logger.
    # @return [TwsApi::Client]
    def initialize(logger:)
      @client_signal = Java::ComIbClient::EJavaSignal.new
      @client = Java::ComIbClient::EClientSocket.new(self, client_signal)
      @current_request_id = 0

      @logger = logger
    end

    # Establishes a connection to the Interactive Brokers (TwsApi) API server.
    #
    # @param host [String] The hostname or IP address to connect to; defaults to '127.0.0.1'.
    # @param port [Integer] The port number on the host to connect to; defaults to 4002.
    # @param client_id [Integer] The identifier for this client connection; defaults to 0.
    def connect(host: '127.0.0.1', port: 4002, client_id: 0)
      client.e_connect(host, port, client_id)
      # Start a thread to keep the data connection line open
      reader = Java::ComIbClient::EReader.new(@client, client_signal)
      reader.start

      Thread.new do
        while client.connected?
          client_signal.wait_for_signal
          begin
            reader.process_msgs
          rescue StandardError => e
            error(e)
          end
        end
      end
    end

    # Disconnects the client from the Interactive Brokers API server.
    def disconnect
      client.e_disconnect
    end

    private

    def connect_ack
      logger.info '---------------------- OPEN ----------------------'
    end

    def connection_closed
      logger.info '--------------------- CLOSED ---------------------'
    end

    def error(*args)
      case args.size
      when 1
        logger.error args[0]
        logger.error args[0].backtrace if args[0].is_a?(Exception)
      when 4
        logger.error "Error Id=#{args[0]} code=#{args[1]} msg=#{args[2]} advanced_order_reject_json=#{args[3]}"
      end
    end

    def next_valid_id(req_id = nil)
      if req_id
        @current_request_id = req_id
      else
        @current_request_id += 1
      end
    end
  end
end
