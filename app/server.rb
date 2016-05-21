require 'em-websocket'
require 'thin'
require 'sinatra'
require 'json'
require './app/bot.rb'

set :public_folder, './app'

EM.run do
  class App < Sinatra::Application
    get "/" do
      File.read('app/index.html')
    end

    post "/bot" do
      return "hoge"
    end


  end
  server = Thin::Server.start App, '0.0.0.0', 9000


  connections = []
  EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 3000) do |ws|
    ws.onopen do
      connections << ws
    end

    ws.onmessage do |message|
      if message.include?("bot") then
        message = message.split(" ")
        command = message[1]
        data = message[2]

        c = {
          :"command" => message[1],
          :"data" => message[2]
        }

        bot = Bot.new(c)
        bot.generateHash()
        message = bot.hash
      end

      connections.each do |conn|
        message = {
          "data"=> message
        }
        conn.send(message.to_json)
      end

    end
  end
end  
