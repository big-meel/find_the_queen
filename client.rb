require 'socket'

class Client
  def initialize(addr, port)
    @socket = TCPSocket.new("localhost", 7621) # TODO: Substitute for env variables

    @request = send_request
    @response = listen_response

    @request
    @response.join
  end

  def send_request
    puts "Please Enter username and password to connect: "
    Thread.new do
      loop do
        message = $stdin.gets.chomp
        @socket.puts message
      end
    end
  end

  def listen_response
    Thread.new do
      loop do
        response = @socket.gets.chomp
        puts "#{response}"
      end
    end
  end
end

Client.new("localhost", 7621)