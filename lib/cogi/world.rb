module Cogi
  class World
    attr_reader :window
    attr_reader :tile_size

    attr_reader :gravity

    def initialize(window, tile_size=16)
      @window = window
      @tile_size = tile_size
      @camera_x = 0
      @camera_y = 0

      @tileset = Gosu::Image.load_tiles("media/earth.bmp", tile_size, tile_size, :tileable => true)

      @block_map = {
        dirt: Block.new(self, 0),
        rock: Block.new(self, 2)
      }

      fill(0, 0, 1000, 1000)

      # @character = Cogi::Character.new(world: self)
      @gravity = 2
    end

    def half_tile_size
      @__half_tile_size ||= tile_size / 2
    end

    def event_bus
      @__event_bus ||= EventBus.new
    end

    ##
    # Fill the defined box with blocks.
    def fill(cx, cy, half_width, half_height)
      surface = cy

      ((cx - half_width)..(cx + half_width)).each { |x|
        ((cy - half_height)..(cy + half_height)).each { |y|
          # if y <= surface
            put_block(x, y, @block_map[:dirt].dup)
          # end
        }
      }

      put_block(0, 0, @block_map[:rock].dup)
    end

    ##
    # Retrieve the block at the specified block coordinates.
    def block_at(x, y)
      _grid.get(x, y)
    end

    ##
    # Put a block at the (x, y) coordinates. These are block coordinates, not
    # pixel coordinates.
    def put_block(x, y, block)
      _grid.set(x, y, block)
    end

    def draw
      cx = window.camera_x / tile_size
      cy = window.camera_y / tile_size
      hw = (window.half_width / tile_size) + 1 # Draw extra block to cover gap
      hh = (window.half_height / tile_size) + 1 # Draw extra block to cover gap

      count = 0

      _grid.each_within(cx, cy, hw, hh) { |x, y, block|
        block.draw(x, y)
        count += 1
      }
      # @character.draw
    end

    ##
    # Draw a tile at a given (x, y) coordinates. These are block coordinates, not
    # pixel coordinates.
    def draw_tile(tile_id, x, y)
      @tileset[tile_id].draw(
        x * tile_size + window.half_width - half_tile_size - window.camera_x,
        -y * tile_size + window.half_height - half_tile_size + window.camera_y,
        0
      )
    end

    def update
      # @character.update
    end

    private

    def _grid
      @__grid ||= Grid.new
    end
  end # World
end # Cogi
