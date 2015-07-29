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

      fill(0, 0, 31, 20)
      put_block(0, 0, @block_map[:rock].dup)

      # @character = Cogi::Character.new(world: self)
      @gravity = 2
    end

    def half_tile_size
      @__half_tile_size ||= tile_size / 2
    end

    def event_bus
      @__event_bus ||= EventBus.new
    end

    def fill(cx, cy, half_width, half_height)
      surface = cy

      ((cx - half_width)..(cx + half_width)).each { |x|
        ((cy - half_height)..(cy + half_height)).each { |y|
          # if y <= surface
            put_block(x, y, @block_map[:dirt].dup)
          # end
        }
      }
    end

    def block_at(x, y)
      _grid.get(x, y)
    end

    def put_block(x, y, block)
      _grid.set(x, y, block)
    end

    def draw
      _grid.each { |x, y, block|
        block.draw(x, y)
      }
      # @character.draw
    end

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
