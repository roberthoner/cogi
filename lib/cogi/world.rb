module Cogi
  class World
    attr_reader :width
    attr_reader :height
    attr_reader :tile_size

    def initialize(width, height, tile_size=64)
      @width = width
      @height = height
      @tile_size = tile_size

      @tileset = Gosu::Image.load_tiles("media/earth.bmp", tile_size, tile_size, :tileable => true)

      @tiles = Array.new(width) { |x|
        Array.new(height) { |y|
          if (x + y) % 2 == 0
            1
          else
            0
          end
        }
      }
    end

    def draw
      width.times { |x|
        height.times { |y|
          if (tile=@tiles[x][y])
            @tileset[tile].draw(x * tile_size, y * tile_size, 0)
          end
        }
      }
    end
  end # World
end # Cogi
