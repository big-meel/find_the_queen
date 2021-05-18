require 'socket'

class Client
  def initialize(addr, port)
    @socket = TCPSocket.open("localhost", 7621) # TODO: Substitute for env variables

    # @request = send_request
    # @response = listen_response

    # @request.join
    # @response.join


    while line = @socket.gets
      # line.chop
      puts line
    end
  end

  def send_request

  end

  def listen_response
  end
end

Client.new("localhost", 7621)