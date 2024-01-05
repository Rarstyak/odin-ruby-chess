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

# board.coor_clear([0,0])
board.coor_clear([1,0])
board.coor_clear([1,1])
board.coor_clear([2,0])
board.coor_clear([2,1])
board.coor_clear([3,0])
board.coor_clear([3,1])
board.coor_clear([3,6])
queen_black = Queen.new(:black)
board.coor_place([6,4], queen_black)

board.print_board(true, true)

puts "can white q? #{board.can_castle?(:white, 'queenside')}"
puts "can white k? #{board.can_castle?(:white, 'kingside')}"
puts "can black q? #{board.can_castle?(:black, 'queenside')}"
puts "can black k? #{board.can_castle?(:black, 'kingside')}"

puts board.who_turn

p board.get_color_threat(:white)
puts ''
puts board.get_color_threat_moves(:white)

# pawn_white = Pawn.new(:white)
# pawn_black = Pawn.new(:black)
# knight_white = Knight.new(:white)
# Knight.new(:black)
# queen_white = Queen.new(:white)

# puts pawn_white
# var = pawn_white.class.name
# p var

# board.coor_clear([4,6])
# board.coor_place([4,4], queen_white)
# board.print_board

# p board.list_pieces
# puts 'notation'
# p board.list_pieces(false)

# p board.get_piece([0, 0])
# p board.get_piece([0, 0], [1, 1])

# p board.king?(:white)
# p board.check?(:white)

# p board.king?(:black)
# p board.check?(:black)

# puts 'TESTING TIME'
# blank = Board.new(0, [], [])

# blank.coor_place([0, 1], knight_white)
# blank.coor_place([2, 2], pawn_white)
# blank.coor_place([3, 3], pawn_black)

# blank.print_board

# p blank.list_pieces
# p pawn_white.get_threat(blank, [2, 2])

# pawn_white.get_threat(blank, [2, 2]).each do |coor|
#   blank.coor_place(coor, queen_white)
# end

# blank.print_board

# p pawn_white.get_threat(blank, [2, 2])

# p blank.king?(:black)
