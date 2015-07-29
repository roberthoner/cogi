module Cogi
  class Character
    attr_reader :world
    attr_reader :tile_size
    attr_reader :x, :y
    attr_reader :x_vel, :y_vel

    def initialize(params={})
      @world = params[:world] or raise "must define world"
      @tile_size = world.tile_size
      @tileset = Gosu::Image.load_tiles("media/guy.png", tile_size, tile_size * 2, :tileable => true)

      @x = (world.width * tile_size / 2).floor
      @y = 0

      @x_vel = @y_vel = 0
    end

    def draw
      @tileset[0].draw(x, y, 0)
    end

    def update
      if (blk=block_under) && blk.solid?
        @y_vel = 0
      else
        @y_vel += world.gravity
      end

      if @x_vel > 0
        @x += @x_vel unless (blk=block_right) && blk.solid?
      elsif @x_vel < 0
        @x += @x_vel unless (blk=block_left) && blk.solid?
      end

      if @y_vel > 0
        steps = (1..@y_vel).each { |s| @y += 1 unless (blk=block_under) && blk.solid? }
      elsif @y_vel < 0
        steps = (1..-@y_vel).each { |s| @y -= 1 unless (blk=block_under) && blk.solid? }
      end
    end

    def block_under
      # Adding 2 for the height of the character.
      world.block_at(x / tile_size, (y / tile_size) + 2)
    end

    def block_above
      world.block_at(x / tile_size, (y / tile_size) - 1)
    end

    def block_right
      world.block_at((x / tile_size) + 1, y / tile_size)
    end

    def block_left
      world.block_at((x / tile_size) - 1, y / tile_size)
    end
  end # Character
end # Cogi
