class Board
  include CharacterSet

  COL_LEN = 8
  ROW_LEN = 8
  GRID = Array.new(ROW_LEN) { |x| Array.new(COL_LEN) {|y| Cell.new(x, y)} }

  initialize

  end

  def coor(x, y)
    if x.between?(0, COL_LEN - 1) && y.between?(0, ROW_LEN - 1)
      grid[x][y]
    else
      nil
    end
  end

  def print_board
    for y in (0...COL_LEN).to_a.reverse do
      for x in 0...ROW_LEN do
        print grid[x][y]
      end
      puts ''
    end
  end
end
