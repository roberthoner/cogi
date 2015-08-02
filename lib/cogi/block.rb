module Cogi
  class Block
    attr_reader :world
    attr_reader :tile_id

    def initialize(world, tile_id)
      @world = world
      @tile_id = tile_id
    end

    ##
    # Whether or not the block is solid (i.e., cannot be passed through).
    def solid?
      true
    end
  end # Block
end # Cogi
