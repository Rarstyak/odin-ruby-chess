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
board.print_board(true, true)

pawn_white = Pawn.new(:white)
pawn_black = Pawn.new(:black)
knight_white = Knight.new(:white)
knight_black = Knight.new(:black)
queen_white = Queen.new(:white)

puts pawn_white
var = pawn_white.class.name
p var

board.notation_place('g4', pawn_white)

board.print_board

p board.list_pieces

p board.get_piece([0,0])
p board.get_piece([0,0], [1,1])

puts "TESTING TIME"
blank = Board.new(0, [], [])

blank.coor_place([0, 1], knight_white)
blank.coor_place([2, 2], pawn_white)
blank.coor_place([3, 3], pawn_black)

blank.print_board

p blank.list_pieces
p pawn_white.get_threat(blank, [2, 2])

pawn_white.get_threat(blank, [2, 2]).each do |coor|
  blank.coor_place(coor, queen_white)
end

blank.print_board

p pawn_white.get_threat(blank, [2, 2])
