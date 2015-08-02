require 'gosu'

module Cogi
  class Client < Gosu::Window
    attr_reader :game
    attr_reader :camera_x, :camera_y

    def initialize(game)
      @game = game
      super(game.settings.screen_width, game.settings.screen_height, game.settings.full_screen?)
      self.caption = 'Cogi'

      @camera_x = @camera_y = 0
    end

    def tileset
      @__tileset ||= Gosu::Image.load_tiles("media/earth.bmp", tile_size, tile_size, :tileable => true)
    end

    def world
      @__world ||= World.new
    end

    def tile_size
      World::BLOCK_SIZE
    end

    def half_tile_size
      @__half_tile_size ||= tile_size / 2
    end

    def half_width
      @__half_width ||= width / 2
    end

    def half_height
      @__half_height ||= height / 2
    end

    def half_tile_width
      @__half_tile_width ||= half_width / tile_size
    end

    def half_tile_height
      @__half_tile_height ||= half_height / tile_size
    end

    def start
      raise "Already started" if @__started

      # Begin the Gosu window processing.
      show

      @__started = true
    end

    ##
    # Gosu Methods
    ##

    def draw
      _render_world
    end

    def update

    end

    def button_down(id)
      close if id == Gosu::KbEscape

      case id
      when Gosu::KbUp
        @camera_y += tile_size
      when Gosu::KbRight
        @camera_x += tile_size
      when Gosu::KbDown
        @camera_y -= tile_size
      when Gosu::KbLeft
        @camera_x -= tile_size
      end
    end

    private

    ##
    # Render the world on the screen. Only draws what is visible to the camera.
    def _render_world
      cx = camera_x / tile_size
      cy = camera_y / tile_size
      hw = half_tile_width + 1 # Draw extra block to cover gap
      hh = half_tile_height + 1 # Draw extra block to cover gap

      world.layer(:block).each_within(cx, cy, hw, hh) { |x, y, block|
        _draw_block(x, y, block)
      }
    end

    ##
    # Draws a block at the specified block coordinates.
    def _draw_block(x, y, block)
      tileset[block.tile_id].draw(
        x * tile_size + half_width - half_tile_size - camera_x,
        -y * tile_size + half_height - half_tile_size + camera_y,
        0
      )
    end
  end # Client
end # Cogi
