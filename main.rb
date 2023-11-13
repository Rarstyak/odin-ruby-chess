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
board.print_board(true)

pawn = Pawn.new(:white)
puts pawn
var = pawn.class.name
p var

board.notation_place('g4', pawn)

board.print_board(true)
