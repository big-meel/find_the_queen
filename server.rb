# Adds socket library
require 'socket'

# TODO: Closes server when both users have logged out
# TODO

class GameServer
  attr_accessor :round
  def initialize(addr, port, authorized_clients)
    @server_socket = TCPServer.open(addr, port)

    @authorized_clients = authorized_clients
    @round = 0
    
    @options = Hash.new

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
        client.puts "Checking for other player"
        
        if @players.keys.count == 2
          client.puts ""
          client.puts "Lets Begin!"
          client.puts ""

          # Create roles for each user
          assign_roles()

          @players.keys.each do |user|
            get_client_connection(user).puts " < ---- You are #{get_role(user)}"
          end
          
          stream( uname, client )

          client.close
        end
      end
    }.join
  end

  def assign_roles
    first_to_login = @players.keys[0].to_sym
    second_to_login = @players.keys[1].to_sym

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

    @players[first_to_login] << { :wins => 0}
    @players[second_to_login] << { :wins => 0}
  end

  # Get TCP Object of players
  def get_client_connection(key)
    @players[key][0][:client]
  end

  # Get Role
  def get_role(username)
    @players[username.to_sym][1][:role]
  end

  def check_winner(username, connection, message)

  end


  def stream(username, connection)
    while round < 5 do
      @players.keys.each do |user|
        get_client_connection(user).puts (get_role(user) == "Dealer" ? 
        "Hide The Queen! Select a number between 0 and 4: " :
        "Spot the Queen! Select a number between 0 and 4: "
      )
      end
      
      message = connection.gets.chomp

      until (1..3).include? message.to_i do
        message = connection.gets.chomp
      end

      @players.keys.each do |user|
        get_client_connection(user).puts "Waiting for opponent..."
      end

      if @options.count == 2
        @players.keys.each do |user|
          get_client_connection(user).puts "Results"
        end
      end

      # TODO: Add winning conditions for each round
      # TODO: Add message for winner at end of 5 rounds

      round += 1
    end
  end

end

authorized_clients =  [ {"dannyboi" => "dre@margh_shelled"}, {"matty7" => "win&win99" }] 
GameServer.new("localhost", 7621, authorized_clients )