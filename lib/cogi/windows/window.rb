require 'gosu'

module Cogi
  class Window < Gosu::Window
    def initialize(width, height, caption="Cogi Window")
      super(width, height)
      self.caption = caption
    end

    def event_bus
      @__event_bus ||= EventBus.new
    end

    def half_width
      @__half_width ||= width / 2
    end

    def half_height
      @__half_height ||= height / 2
    end

    ##
    # Gosu Methods
    ##

    def draw
    end

    def update
      event_bus.step
    end

    def button_down(id)
      close if id == Gosu::KbEscape
    end
  end
end
