# frozen_string_literal: true

require 'socket'
require 'fileutils'

class TCPProxy
  def initialize(source_port:, destination_port:, example_metadata:, destination_host: 'localhost')
    @source_port = source_port
    @destination_port = destination_port
    @destination_host = destination_host
    @threads = []
    @file_mutex = Mutex.new
    @example_metadata = example_metadata
    @record = example_metadata.dig(:tcp_proxy, :record) if example_metadata[:tcp_proxy].is_a?(Hash)
    @record ||= :once
    @record_file = fixture_file
  end

  def start
    @server_socket = TCPServer.new(@source_port)

    Thread.start(@server_socket.accept) do |server_connection|
      if create_recording?
        @client_socket = TCPSocket.new(@destination_host, @destination_port)
        @threads << forward_data(server_connection, @client_socket, direction: 'Client->TWS')
        @threads << forward_data(@client_socket, server_connection, direction: 'TWS->Client')
      else
        @threads << reply_record(server_connection)
      end
      @threads << Thread.current
    end
  rescue StandardError => e
    puts "An error occurred: #{e}"
    close
  end

  def close
    @threads.each do |thread|
      thread.kill unless thread == Thread.current
    end
    @threads.clear
    @server_socket&.close
    @client_socket&.close
    @record_file.close
  end

  private

  def log(msg)
    RSpec.logger.debug(msg)
  end

  def forward_data(source, destination, direction:)
    puts "open: #{source} -> #{destination}"
    Thread.new do
      while (msg = source.readpartial(4096))
        puts "#{direction}: #{msg}"
        @file_mutex.synchronize do
          @record_file.write "#{direction}:#{msg}\n"
        end
        destination.write(msg)
      end
    rescue EOFError
      close
    rescue StandardError => e
      puts "error #{direction}: #{e}"
      close
    end
  end

  def reply_record(source)
    puts "open: #{source} -> record"
    Thread.new do
      recorded_lines = @record_file.readlines.map(&:chomp).reverse
      cmp = recorded_lines.pop
      while (msg = source.readpartial(4096))
        if cmp.nil? # end of recording
          close
        elsif cmp[12..] == msg.chomp
          loop do
            next_line = recorded_lines.pop
            if next_line && next_line[0..11] == 'TWS->Client:'
              puts "write to socket\n"
              source.write(next_line[12..])
            else
              puts "next client\n"
              cmp = next_line
              break
            end
          end
        else
          puts "blabla\n"
          puts msg
          puts cmp
        end
      end
    rescue EOFError
      close
    rescue StandardError => e
      puts "error Client->TWS: #{e}\n#{e.backtrace}"
      close
    end
  end

  def cassette_name_for(metadata)
    description = metadata[:description]
    example_group = metadata.key?(:example_group) ? metadata[:example_group] : metadata[:parent_example_group]

    if example_group
      [cassette_name_for(example_group), description].join('/')
    else
      description
    end
  end

  def record_file_with_path
    @record_file_with_path ||= "#{@example_metadata[:fixtures_path]}/#{cassette_name_for(@example_metadata)}.bin"
  end

  def fixture_file
    File.new(record_file_with_path, 'r') unless create_recording?

    unless File.exist?(record_file_with_path)
      path, _file_name = File.split(record_file_with_path)
      FileUtils.mkdir_p(path)
    end
    File.new(record_file_with_path, 'a+')
  end

  def create_recording?
    @create_recording ||= @record == :all || (@record == :once && !File.exist?(record_file_with_path))
  end
end

RSpec.configure do |config|
  config.around(:each, :tcp_proxy) do |example|
    @tcp_proxy = TCPProxy.new(source_port: 9999, destination_port: 4002, example_metadata: example.metadata)
    Thread.new { @tcp_proxy.start }
    sleep 0.1

    begin
      example.run
    ensure
      @tcp_proxy&.close
    end
  end
end
