class Tile
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end
end

class Board
  attr_reader :tile_list

  def initialize(dimensions=8)
    @tile_list = populate_with_tiles(dimensions)
  end

  def populate_with_tiles(dimensions)
    [].tap do |tile_bag|
      (1..dimensions).each do |x_val|
        (1..dimensions).each do |y_val|
          tile_bag << Tile.new(x_val, y_val)
        end
      end
    end
  end


end

class Queen
  attr_reader :position

  def initialize(x,y)
    @position = [x,y]
  end

  def remove_illegal_tiles(tile_list)
    # Go through all the tiles, removing any that are in the line of a newly placed queen.
    legal_tiles = tile_list.select do |tile|
      !self.conflicts?(tile)
    end
    legal_tiles
  end

  def conflicts?(tile)
    this_x, this_y = self.position
    other_x = tile.x
    other_y = tile.y

    #check rows and columns
    if this_x == other_x || this_y == other_y
      return true
    end
    #check diags
    slope = (this_y - other_y).to_f / (this_x - other_x).to_f
    return true if [1.0, -1.0].include?(slope)

    false
  end

end

#This is actually an n-queens solution, though it takes a really long time beyond a 12X12 board or so
class Computation

  def initialize(dimensions=8, solutions=1)
    @solutions_desired = solutions
    @n_queens = dimensions
    @board = Board.new(dimensions)
    solutions = []

    until solutions.count == @solutions_desired
      solution = solve(@board.tile_list, []).sort
      solutions << solution unless solutions.include?(solution)
    end

    puts "Here are the solutions to an #{dimensions}-queens problem"
    solutions.each do |solution|
      p solution
    end
    nil
  end

  def solve(tile_list, queens_list)
    #base cases
    if queens_list.length == @n_queens
      return queens_list.map{|queen| queen.position }
    elsif tile_list.empty?
      return false
    else
      return_value = false
      tile_list.shuffle.each do |tile|
        queen_to_try = Queen.new(tile.x, tile.y)
        tile_list_to_try = queen_to_try.remove_illegal_tiles(tile_list)
        added_queen_list = queens_list + [queen_to_try]
        if solve(tile_list_to_try, added_queen_list)
          return solve(tile_list_to_try, added_queen_list)
        end
      end
      return false
    end
  end
end

