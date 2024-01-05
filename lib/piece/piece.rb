# frozen_string_literal: true

# parent class Piece
# should serialize into piece type(sub class), color
class Piece
  include CharacterSet

  PREFIX = ''

  attr_reader :color#, :last_move

  def same_color?(piece)
    @color == piece&.color
  end

  def threaten_rel(board, coor, relative_array)
    list = []
    relative_array.each do |rel|
      rel_cell = board.get_cell(coor, rel)
      list.push(rel_cell&.coor) unless same_color?(rel_cell&.piece)
    end
    list.compact
  end

  def threaten_dir(board, coor, direction_array)
    list = []
    direction_array.each do |dir|
      rel_cell = board.get_cell(coor)
      loop do
        rel_cell = board.get_cell(rel_cell&.coor, dir)
        list.push(rel_cell&.coor) unless same_color?(rel_cell&.piece)
        break if rel_cell.nil? || rel_cell.piece
      end
    end
    list.compact
  end

  # def self.check_direction(board, coor, rel)
  # check_relative until hits a piece
  # end

  # def self.get_threat(board, coor)
  # returns all coor that can move to as an array of start end pairs
  # end

  # def self.get_moves(board, coor)
  #   # ~~return array of all legal destination cells~~
  #   # return hash of all possible board states: key = reversable algebra notation, data = board
  #   # x = cell.file_i
  #   # y = cell.rank_i
  # end

  # def set_last_move(turn)
  #   @last_move = turn
  # end

  def initialize(color)
    @color = color
  end
end
