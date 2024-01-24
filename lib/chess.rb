# frozen_string_literal: true

require 'json'

# Chess
class Chess
  MENUS = [
    {
      input: '1',
      desc: 'New Game',
      method: :new_board
    },
    {
      input: '2',
      desc: 'Save',
      method: :save_board
    },
    {
      input: '3',
      desc: 'Load',
      method: :load_board
    },
    {
      input: '0',
      desc: 'Credits',
      method: :display_credits
    }
  ].freeze

  def menu
    display_intro
    new_board
    loop do
      display_menu
      @board.display_game
      input = gets.chomp
      case MENUS
      in [*, { input: ^input } => option, *]
        # use MENUS if match input
        send(option[:method])
      else
        # otherwise see if input turns into a legal move for the board
        @board.play_move(input)
      end
    end
  end

  def new_board
    @board = Board.new
  end

  def save_board
    @board.save_to_file
  end

  def load_board
    @board.load_from_file
  end

  # Display

  def display_intro
    puts <<~HEREDOC_INTRO

      Runs a CLI game of chess

    HEREDOC_INTRO
  end

  def display_menu
    MENUS.each { |option| puts "#{option[:input]}. #{option[:desc]}" }
    puts ''
  end

  def display_credits
    puts <<~HEREDOC_CREDITS

      Made for the Odin project assignment
      [Ruby Chess](https://www.theodinproject.com/lessons/ruby-ruby-final-project)

      By
      [Rarstyak](https://github.com/Rarstyak)

    HEREDOC_CREDITS
  end
end
