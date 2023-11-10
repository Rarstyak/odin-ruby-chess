# frozen_string_literal: true

require_relative 'character_set'
require_relative 'cell'

# Game Board
class Board
  include CharacterSet

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

  def coor(file_i, rank_i)
    return unless file_i.between?(0, NUM_RANK - 1) && rank_i.between?(0, NUM_FILE - 1)

    GRID[file_i][rank_i]
  end

  def print_board
    (0...NUM_RANK).to_a.reverse.each do |rank_i|
      (0...NUM_FILE).each do |file_i|
        print GRID[file_i][rank_i]
      end
      puts ''
    end
  end
end
