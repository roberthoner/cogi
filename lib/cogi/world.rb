module Cogi
  class World
    ##
    # Size of blocks in pixels
    BLOCK_SIZE = 16

    def initialize
      @block_map = {
        dirt: Block.new(self, 0),
        rock: Block.new(self, 2)
      }

      fill(0, 0, 50, 50)
    end

    ##
    # Fill the defined box with blocks.
    def fill(cx, cy, half_width, half_height)
      surface = cy

      ((cx - half_width)..(cx + half_width)).each { |x|
        ((cy - half_height)..(cy + half_height)).each { |y|
          put_block(x, y, @block_map[:dirt].dup)
        }
      }

      put_block(0, 0, @block_map[:rock].dup)
    end

    ##
    # Retrieve the block at the specified block coordinates.
    def block_at(x, y)
      _layer.get(x, y)
    end

    ##
    # Put a block at the (x, y) coordinates. These are block coordinates, not
    # pixel coordinates.
    def put_block(x, y, block)
      _layer.set(x, y, block)
    end

    def layer(name)
      (@__layers ||= {})[name.to_sym] ||= Layer.new
    end

    private

    def _layer
      layer(:block)
    end
  end # World
end # Cogi
