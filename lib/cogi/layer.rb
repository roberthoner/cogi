require 'set'

module Cogi
  class Layer
    SECTOR_MAGNITUDE = 5
    SECTOR_MASK = 0xFFFFFFFF >> (32 - SECTOR_MAGNITUDE)

    class Quadrant
      class Sector
        def get(x, y)
          _row(y)[x]
        end

        def set(x, y, value)
          _row(y)[x] = value
        end

        private

        def _row(y)
          _rows[y] ||= {}
        end

        def _rows
          @__rows ||= {}
        end
      end # Sector

      def initialize(mult_x, mult_y)
        @mult_x = mult_x
        @mult_y = mult_y
      end

      def get(x, y)
        x, y = _translate_coords(x, y)
        _get(x, y)
      end

      def set(x, y, value)
        x, y = _translate_coords(x, y)
        _set(x, y, value)
      end

      def clear
        _sector_rows.clear
      end

      ##
      # Clears a sector given it's coordinates.
      def clear_sector(sx, sy)
        sx, sy = _translate_coords(sx, sy)
        _set_sector(sx, sy, nil)
      end

      ##
      # Sets the values in a sector.
      def set_sector(sx, sy, values={})
        raise NotImplementedError
      end

      def each_within(cx, cy, hw, hh)
        cx, cy = _translate_coords(cx, cy)

        sx = [0, cx - hw].max # Starting x
        ex = [0, cx + hw].max # Ending x
        sy = [0, cy - hh].max # Starting y
        ey = [0, cy + hh].max # Ending y

        (sy..ey).each { |y|
          (sx..ex).each { |x|
            if (val=_get(x, y))
              yield x * @mult_x, y * @mult_y, val
            end
          }
        }
      end

      def inspect
        [ "Quad(#{@mult_x}, #{@mult_y})",
          # "Size: #{count}",
          _sector_rows.inspect
        ].join("\n")
      end

      private

      def _get(x, y)
        if (sector=_get_sector(x, y))
          sector.get(x & SECTOR_MASK, y & SECTOR_MASK)
        end
      end

      def _set(x, y, value)
        sector = _get_sector(x, y) || _set_sector(x, y, Sector.new)
        sector.set(x & SECTOR_MASK, y & SECTOR_MASK, value)
      end

      def _translate_coords(x, y)
        [x * @mult_x, y * @mult_y]
      end

      def _get_sector(x, y)
        _sector_row(y)[x >> SECTOR_MAGNITUDE]
      end

      def _set_sector(x, y, value)
        _sector_row(y)[x >> SECTOR_MAGNITUDE] = value
      end

      def _sector_row(y)
        _sector_rows[y >> SECTOR_MAGNITUDE] ||= {}
      end

      def _sector_rows
        @__sector_rows ||= {}
      end
    end # Quadrant

    def get(x, y, default=nil)
      _select_quad(x, y).get(x, y, default)
    end

    def set(x, y, value)
      _select_quad(x, y).set(x, y, value)
    end

    def unset(x, y)
      set(x, y, nil)
    end

    def clear
      _quadrants.each_value { |quad| quad.clear }
    end

    def clear_sector(sx, sy)
      _select_quad(sx, sy).clear_sector(sx, sy)
    end

    def set_sector(sx, sy, values={})
      _select_quad(sx, sy).set_sector(sx, sy, values)
    end

    ##
    # Iterate through each of the values within the containing box.
    # The center of the box is at (cx, cy).
    def each_within(cx, cy, half_width, half_height, &block)
      _quadrants.each_value { |quad| quad.each_within(cx, cy, half_width, half_height, &block) }
    end

    def inspect
      _quadrants.values.map { |q| q.inspect }.join("\n\n")
    end

    private

    def _select_quad(x, y)
      _quadrants[_determine_quad(x, y)]
    end

    def _determine_quad(x, y)
      if x >= 0
        y >= 0 ? :ne : :se
      else
        y >= 0 ? :nw : :sw
      end
    end

    def _quadrants
      @__quadrants ||= {
        # North-East Quadrant
        ne: Quadrant.new(1, 1),

        # North-West Quadrant
        nw: Quadrant.new(-1, 1),

        # South-West Quadrant
        sw: Quadrant.new(-1, -1),

        # South-East Quadrant
        se: Quadrant.new(1, -1)
      }
    end
  end # Layer
end # Cogi
