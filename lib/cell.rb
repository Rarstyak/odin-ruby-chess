# frozen_string_literal: true

# Cell
class Cell
  attr_reader :file_i, :rank_i, :coor, :file, :rank, :notation, :piece

  def initialize(file_i, rank_i, piece = nil)
    @file_i = file_i
    @rank_i = rank_i
    @coor = [file_i, rank_i]
    @file = ('a'..'h').to_a[file_i]
    @rank = (rank_i + 1).to_s
    @notation = @file + @rank
    @piece = piece
  end

  def empty?
    @piece.nil?
  end

  def clear
    @piece = nil
  end

  def set(piece)
    @piece = piece
  end

  def to_s
    empty? ? '.' : @piece.to_s
  end
end
