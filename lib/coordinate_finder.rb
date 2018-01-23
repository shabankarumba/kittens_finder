# frozen_string_literal: true

class CoordinateFinder
  CORRECT_DIRECTIONS = %w[forward left right].freeze
  IncorrectDirection = StandardError.new('Incorrect direction provided')

  def initialize(directions)
    @directions = directions
  end

  def call
    coordinates = Coordinates.new(x: 0, y: 0)

    directions.map do |direction|
      raise IncorrectDirection unless CORRECT_DIRECTIONS.include?(direction)
      coordinates.public_send(direction.to_sym)
    end

    { x: coordinates.x, y: coordinates.y }
  end

  private

  attr_reader :directions

  class Coordinates
    attr_reader :x, :y
    def initialize(x: 0, y: 0, turnings: 0)
      @x = x
      @y = y
      @turnings = turnings
    end

    def facing
      directions[turnings % directions.count]
    end

    def left
      @turnings -= 1
    end

    def right
      @turnings += 1
    end

    def forward
      case facing
      when :left
        @x -= 1
      when :right
        @x += 1
      when :forward
        @y += 1
      when :backward
        @y -= 1
      end
    end

    def directions
      %i[forward right backward left]
    end

    private

    attr_reader :turnings
  end
end
