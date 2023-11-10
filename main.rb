# frozen_string_literal: true

require_relative './lib/chess'

require_relative './lib/board'

require_relative './lib/piece/bishop'
require_relative './lib/piece/king'
require_relative './lib/piece/knight'
require_relative './lib/piece/pawn'
require_relative './lib/piece/queen'
require_relative './lib/piece/rook'

board = Board.new
board.print_board

cell = Cell.new(0, 0)

pawn = Pawn.new(:white, cell)
puts pawn

bishop = Bishop.new(:black, cell)
puts bishop

king = King.new(:white, cell)
puts king

knight = Knight.new(:black, cell)
puts knight

queen = Queen.new(:white, cell)
puts queen

rook = Rook.new(:black, cell)
puts rook
