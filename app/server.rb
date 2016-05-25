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
        msg = message.split(" ")
        command = msg[1]
        data = msg[2]

        c = {
          :"command" => msg[1],
          :"data" => msg[2]
        }

        bot = Bot.new(c)
        bot.generateHash()

        bot_msg = {
          "data" => bot.hash
        }

        puts bot.hash

      end

      message = {
        "data"=> message
      }

      connections.each do |conn|
        conn.send(message.to_json)
        conn.send(bot_msg.to_json)  unless bot_msg.nil?
      end

    end
  end
end  
