# frozen_string_literal: true

# Player
class Player
  attr_reader :name, :wins, :ties, :losses

  def initialize(name)
    @name = name
    @wins = 0
    @ties = 0
    @losses = 0
  end

  def win
    @wins += 1
  end

  def tie
    @ties += 1
  end

  def lose
    @losses += 1
  end

  def to_s
    "#{name} (#{wins}:#{ties}:#{losses})"
  end
end
