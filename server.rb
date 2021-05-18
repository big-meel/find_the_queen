# Adds socket library
require 'socket'

class GameServer
  def initialize(addr, port, authorized_clients)
    @server_socket = TCPServer.open(addr, port)

    @authorized_clients = authorized_clients

    puts 'Starting Server.....'
    run_server
  end


  def run_server
    loop {
      client = @server_socket.accept
      Thread.start(client) do |client|

        client.puts "Username: "
        uname = client.gets.chomp


        client.puts "Password: "
        pword = client.gets.chomp

        login = { uname.to_s => pword.to_s }
        unless @authorized_clients.include? login
          client.puts "Login credentials incorrect...."
          client.puts "Closing connection"
          client.kill self
        end


        client.puts "#{client} is Connected"
        # client.close
      end
    }.join
  end


end

authorized_clients = [ {"dannyboi" => "dre@margh_shelled"}, {"matty7" => "win&win99"} ]
GameServer.new("localhost", 7621, authorized_clients )