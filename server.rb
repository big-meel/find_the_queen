# Adds socket library
require 'socket'

class GameServer
  def initialize(addr, port)
    @server_socket = TCPServer.open(addr, port)


    puts 'Starting Server.....'
    run_server
  end


  def run_server
    loop {
      client = @server_socket.accept
      Thread.start(client) do |client|
        client.puts "#{client} is Connected"
        client.close
      end
    }
  end


end


GameServer.new("localhost", 7621)