require 'gosu'

module Cogi
  class GameWindow < Window
    attr_reader :config
    attr_reader :camera_x
    attr_reader :camera_y

    def initialize(config={})
      super(config[:width], config[:height], config[:caption] || "Cogi Game Window")

      @camera_x = 0
      @camera_y = 0
    end

    def world
      @__world ||= World.new(self)
    end

    def draw
      world.draw
    end

    def update
      super
      world.update
    end

    def button_down(id)
      super
      case id
      when Gosu::KbUp
        @camera_y += 16
      when Gosu::KbRight
        @camera_x += 16
      when Gosu::KbDown
        @camera_y -= 16
      when Gosu::KbLeft
        @camera_x -= 16
      end
    end
  end
end
