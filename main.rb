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

puts pawn_white
var = pawn_white.class.name
p var

board.notation_place('g4', pawn_white)

board.print_board

p board.list_pieces

p board.get_piece([0,0])
p board.get_piece([0,0], [1,1])

puts "TESTING TIME"
knight = Knight.new(:white)
blank = Board.new(0, [], [])
blank.print_board
p blank.list_pieces
knight.get_threat(blank, [4,4]).each do |coor|
  blank.coor_place(coor, pawn_white)
end
blank.coor_place([5,6], pawn_black)


blank.print_board

p knight.get_threat(blank, [4,4])

puts "TESTING TIME Rook"
rook = Rook.new(:white)
blank = Board.new(0, [], [])
blank.coor_place([4,6], pawn_black)
blank.coor_place([4,1], knight_white)
blank.print_board
p blank.list_pieces
rook.get_threat(blank, [4,4]).each do |coor|
  blank.coor_place(coor, pawn_white)
end


blank.print_board

p rook.get_threat(blank, [4,4])

puts "TESTING TIME Bishop"
bishop = Bishop.new(:white)
blank = Board.new(0, [], [])
blank.coor_place([4,6], pawn_black)
blank.coor_place([5,1], knight_white)
blank.print_board
p blank.list_pieces
bishop.get_threat(blank, [2,4]).each do |coor|
  blank.coor_place(coor, pawn_white)
end


blank.print_board

p bishop.get_threat(blank, [4,4])

puts "TESTING TIME Queen"
queen = Queen.new(:white)
blank = Board.new(0, [], [])
blank.coor_place([4,6], pawn_black)
blank.coor_place([4,1], knight_white)
blank.print_board
p blank.list_pieces
queen.get_threat(blank, [4,4]).each do |coor|
  blank.coor_place(coor, pawn_white)
end


blank.print_board

p queen.get_threat(blank, [4,4])
