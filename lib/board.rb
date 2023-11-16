# frozen_string_literal: true

require_relative 'character_set'
require_relative 'notation'
require_relative 'cell'

# Game Board
class Board
  include CharacterSet
  include Notation

  NUM_FILE = 8
  NUM_RANK = 8
  PIECE_TYPES = %w[Rook Knight Bishop Queen King Pawn].freeze
  DEFAULT_PIECES = [
    [[0,7], 'Rook', :black],
    [[1,7], 'Knight', :black],
    [[2,7], 'Bishop', :black],
    [[3,7], 'Queen', :black],
    [[4,7], 'King', :black],
    [[5,7], 'Bishop', :black],
    [[6,7], 'Knight', :black],
    [[7,7], 'Rook', :black],

    [[0,6], 'Pawn', :black],
    [[1,6], 'Pawn', :black],
    [[2,6], 'Pawn', :black],
    [[3,6], 'Pawn', :black],
    [[4,6], 'Pawn', :black],
    [[5,6], 'Pawn', :black],
    [[6,6], 'Pawn', :black],
    [[7,6], 'Pawn', :black],

    [[0,1], 'Pawn', :white],
    [[1,1], 'Pawn', :white],
    [[2,1], 'Pawn', :white],
    [[3,1], 'Pawn', :white],
    [[4,1], 'Pawn', :white],
    [[5,1], 'Pawn', :white],
    [[6,1], 'Pawn', :white],
    [[7,1], 'Pawn', :white],

    [[0,0], 'Rook', :white],
    [[1,0], 'Knight', :white],
    [[2,0], 'Bishop', :white],
    [[3,0], 'Queen', :white],
    [[4,0], 'King', :white],
    [[5,0], 'Bishop', :white],
    [[6,0], 'Knight', :white],
    [[7,0], 'Rook', :white],
  ].freeze

  # Castling requires the king and that rook haven't moved, that they are both there, and there are no inbetween
  # These 6 booleans + cell checks are all needed since if they are killed, they can't be there
  def initialize(turn = 0, pieces_array = DEFAULT_PIECES,
                 history = [],
                 moved = { a8: false, e8: false, h8: false, a1: false, e1: false, h1: false })
    @grid = Array.new(NUM_FILE) { |file_i| Array.new(NUM_RANK) { |rank_i| Cell.new(file_i, rank_i) } }
    @turn = turn
    @history = history
    @moved = moved # make a whole method for searching the history stack instead??? esp for taking en passant
    load_pieces(pieces_array)
  end

  def notation_place(notation, piece)
    coor_place(coor_from_notation(notation), piece)
  end

  def notation_move(start_notation, end_notation)
    coor_move(coor_from_notation(start_notation), coor_from_notation(end_notation))
  end

  # def play_move(start_coor, end_coor)
  #   return if not legal
  #   coor_move
  #   add to history -> includes @turn += 1
  # end

  def other_color(color)
    color == :white ? :black : :white
  end

  def check?(color)
    get_color_threat(other_color(color)).include?(king?(color))
  end

  def king?(color)
    case list_pieces
    in [*, [_ => k_coor, 'King', ^color], *]
      k_coor
    else
      nil
    end
  end

  # Checks standard movement threat, ignores enpassant and castling which can not be used to kill a king
  def get_color_threat(color)
    list = []
    @grid.flatten.each do |cell|
      list.concat(cell.piece.get_threat(self, cell.coor)) unless cell.empty?
    end
    list
  end

  def coor_move(start_coor, end_coor)
    piece = get_piece(start_coor)
    coor_place(end_coor, piece)
    coor_clear(start_coor)
  end

  def coor_place(coor, piece)
    get_cell(coor)&.set(piece)
  end

  def coor_clear(coor)
    get_cell(coor)&.clear
  end

  def get_piece(coor, rel = [0, 0])
    get_cell([coor[0] + rel[0], coor[1] + rel[1]])&.piece
  end

  def get_cell(coor, rel = [0, 0])
    return unless coor_is_valid?([coor[0] + rel[0], coor[1] + rel[1]])

    @grid[coor[0] + rel[0]][coor[1] + rel[1]]
  end

  # IO

  def list_pieces(coor = true)
    list = []
    @grid.flatten.each do |cell|
      list.push([coor ? cell.coor : cell.notation, cell.piece.class.name, cell.piece.color]) unless cell.empty?
    end
    list
  end

  def load_pieces(pieces_array)
    pieces_array.each do |entry|
      coor_place(entry[0], eval(entry[1]).new(entry[2].to_sym)) if PIECE_TYPES.include?(entry[1])
    end
  end

  # Display

  def display_turn
    puts "Turn #{(@turn / 2).floor + 1} for #{@turn.even? ? 'white' : 'black'}"
  end

  def display_history
    history.each_with_index do |item, turn|
      print "#{(@turn / 2).floor + 1}. #{item}" if turn.even?
      puts " #{item}" if turn.odd?
    end
  end

  def display_cell(file_i, rank_i, bg_color_even = "\e[0m", bg_color_odd = "\e[0m")
    print (rank_i + file_i).even? ? bg_color_even : bg_color_odd
    print @grid[file_i][rank_i]
    print "\e[0m"
  end

  def print_board(with_bg_colors = false, with_labels = false)
    puts ' abcdefgh' if with_labels
    (0...NUM_RANK).to_a.reverse.each do |rank_i|
      print(rank_i + 1) if with_labels
      (0...NUM_FILE).each do |file_i|
        if with_bg_colors
          display_cell(file_i, rank_i, "\e[45m", "\e[42m")
        else
          display_cell(file_i, rank_i)
        end
      end
      print(rank_i + 1) if with_labels
      puts ''
    end
    puts ' abcdefgh' if with_labels
  end
end
