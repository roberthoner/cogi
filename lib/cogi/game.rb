module Cogi
  class Game
    attr_reader :client
    attr_reader :server
    attr_reader :settings

    def initialize(params={})
      @settings = Struct.new(:screen_width, :screen_height, :full_screen?).new(1024, 768, false)
      @server = params[:server]# || Server.new(self)
      @client = params[:client] || Client.new(self)
    end

    def event_bus
      @__event_bus ||= EventBus.new
    end

    ##
    # Start the game
    def start
      client.start
    end
  end # Game
end # Cogi
