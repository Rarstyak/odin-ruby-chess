# frozen_string_literal: true

require_relative 'character_set'
require_relative 'notation'
require_relative 'cell'

# Game Board
class Board
  include CharacterSet
  include Notation

  # Columns, called files are labeled a-h from White's left to right
  # Rows, called ranks, are numbered 1-8 from white to bplack
  # The pieces uppercase letter + destination coor
  # pawns don't have a letter
  # captures insert an "x" before coor; if a pawn captures, the pawn's departure file prefixes
  # en passant can all add " e.p." to end
  # distinguish pieces by file/rank/file&rank if needed

  NUM_FILE = 8
  NUM_RANK = 8
  GRID = Array.new(NUM_FILE) { |file_i| Array.new(NUM_RANK) { |rank_i| Cell.new(file_i, rank_i) } }
  PIECE_TYPES = %w[Rook Knight Bishop Queen King Pawn].freeze
  DEFAULT_PIECES = [
    ['a8', 'Rook', :black],
    ['b8', 'Knight', :black],
    ['c8', 'Bishop', :black],
    ['d8', 'Queen', :black],
    ['e8', 'King', :black],
    ['f8', 'Bishop', :black],
    ['g8', 'Knight', :black],
    ['h8', 'Rook', :black],

    ['a7', 'Pawn', :black],
    ['b7', 'Pawn', :black],
    ['c7', 'Pawn', :black],
    ['d7', 'Pawn', :black],
    ['e7', 'Pawn', :black],
    ['f7', 'Pawn', :black],
    ['g7', 'Pawn', :black],
    ['h7', 'Pawn', :black],

    ['a2', 'Pawn', :white],
    ['b2', 'Pawn', :white],
    ['c2', 'Pawn', :white],
    ['d2', 'Pawn', :white],
    ['e2', 'Pawn', :white],
    ['f2', 'Pawn', :white],
    ['g2', 'Pawn', :white],
    ['h2', 'Pawn', :white],

    ['a1', 'Rook', :white],
    ['b1', 'Knight', :white],
    ['c1', 'Bishop', :white],
    ['d1', 'Queen', :white],
    ['e1', 'King', :white],
    ['f1', 'Bishop', :white],
    ['g1', 'Knight', :white],
    ['h1', 'Rook', :white]
  ].freeze

  # Castling requires the king and that rook haven't moved, that they are both there, and there are no inbetween
  # These 6 booleans + cell checks are all needed since if they are killed, they can't be there
  def initialize(turn = 1, pieces = DEFAULT_PIECES,
                 moved = { a8: false, e8: false, h8: false, a1: false, e1: false, h1: false })
    @turn = turn
    @moved = moved
    place_pieces(pieces)
  end

  def place_pieces(pieces_array)
    pieces_array.each do |entry|
      notation_place(entry[0], eval(entry[1]).new(entry[2].to_sym)) if PIECE_TYPES.include?(entry[1])
    end
  end

  def notation_place(notation, piece)
    coor_place(coor_from_notation(notation), piece)
  end

  def coor_place(coor, piece)
    cell = get_cell(coor[:file_i], coor[:rank_i])
    cell&.set(piece)
  end

  def get_cell(file_i, rank_i)
    return unless coor_is_valid?(file_i, rank_i)

    GRID[file_i][rank_i]
  end

  def print_board(with_labels)
    puts ' abcdefgh' if with_labels
    (0...NUM_RANK).to_a.reverse.each do |rank_i|
      print(rank_i + 1) if with_labels
      (0...NUM_FILE).each do |file_i|
        print GRID[file_i][rank_i]
      end
      print(rank_i + 1) if with_labels
      puts ''
    end
    puts ' abcdefgh' if with_labels
  end
end
