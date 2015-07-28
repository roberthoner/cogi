# Encoding: UTF-8

$:<<'lib'

require 'rubygems'
require 'gosu'
require 'cogi'

WIDTH, HEIGHT = 1024, 768

class Welcome < Gosu::Window
  def initialize
    super(WIDTH, HEIGHT)

    self.caption = "Welcome!"

    @world = Cogi::World.new(10, 10)
  end

  def draw
    @world.draw
  end
end

Welcome.new.show if __FILE__ == $0
