require 'set'

module Cogi
  class Grid
    class Quadrant
      def initialize(mult_x, mult_y)
        @mult_x = mult_x
        @mult_y = mult_y
      end

      def get(x, y)
        _row(y * @mult_y)[x * @mult_x]
      end

      def set(x, y, value)
        _row(y * @mult_y)[x * @mult_x] = value
      end

      def clear
        _rows.clear
      end

      def each
        _rows.each { |y, xs|
          xs.each { |x, value|
            yield x * @mult_x, y * @mult_y, value
          }
        }
      end

      def each_within(cx, cy, hw, hh)
        cx *= @mult_x
        cy *= @mult_y

        sx = [0, cx - hw].max # Starting x
        ex = [0, cx + hw].max # Ending x
        sy = [0, cy - hh].max # Starting y
        ey = [0, cy + hh].max # Ending y

        _rows.each { |y, xs|
          if y >= sy && y < ey
            xs.each { |x, value|
              if x >= sx && x < ex
                yield x * @mult_x, y * @mult_y, value
              end
            }
          end
        }
      end

      def count
        _rows.map(&:count).inject(&:+)
      end

      def inspect
        [ "Quad(#{@mult_x}, #{@mult_y})",
          "Size: #{count}",
          _rows.inspect
        ].join("\n")
      end

      private

      def _row(y)
        _rows[y] ||= {}
      end

      def _rows
        @__rows ||= {}
      end
    end # Quadrant

    def get(x, y)
      _select_quad(x, y).get(x, y)
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

    def each(&block)
      _quadrants.each_value { |quad|
        quad.each(&block)
      }
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
  end # Grid
end # Cogi
