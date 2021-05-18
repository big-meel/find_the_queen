# Adds socket library
require 'socket'

class GameServer
  def initialize(addr, port, authorized_clients)
    @server_socket = TCPServer.open(addr, port)

    @authorized_clients = authorized_clients

    @players = Hash.new

    puts 'Starting Server.....'
    run_server
  end

  # Operate Server
  def run_server
    loop {
      client = @server_socket.accept
      Thread.start(client) do |client|

        client.puts "Username: "
        uname = client.gets.chomp


        client.puts "Password: "
        pword = client.gets.chomp

        login = { uname.to_s => pword.to_s }
        unless @authorized_clients.include?(login) && @players.keys.count < 2
          client.puts "Cannot Login..."
          client.puts "Closing connection"
          client.kill self             # TODO: Find replacement method for kill
        else
          if @players.keys.include? uname.to_sym
            client.puts "User is already logged in"
            client.puts "Closing connection"
            client.kill self
          else
            @players[uname.to_sym] = [ {:client => client }]
          end
        end

        
        
        
        client.puts "#{client} is Connected"
        client.puts "#{@players.keys.count} players "
        # client.close
        
        if @players.keys.count == 2
          client.puts ""
          client.puts "Lets Begin!"
          client.puts ""

        end
        
      assign_roles()

      end
    }.join
  end

  # Randomly assign roles to users
  def assign_roles
    # Assigned by order of login
    first_to_login = @player.keys[0]
    second_to_login = @player.keys[1]

    first_number = rand()
    second_number = rand()

    # if  first to login greater; assigned Dealer, if less or equal first to login is assigned Spotter
    if first_number > second_number 
      @players[first_to_login] << { :role => "Dealer" }
      @players[second_to_login] << { :role => "Spotter" }
    else
      @players[first_to_login] << { :role => "Spotter" }
      @players[second_to_login] << { :role => "Dealer" }
    end
  end

  # Get TCP Connection of players
  def get_client_connection(key)
    @players[key][0][:client]
  end

  def stream

  end
end

authorized_clients =  [ {"dannyboi" => "dre@margh_shelled"}, {"matty7" => "win&win99" }] 
GameServer.new("localhost", 7621, authorized_clients )