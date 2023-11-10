# frozen_string_literal: true

# Chess
class Chess
  MENUS = [
    {
      input: '1',
      desc: 'New Game',
      method: :play_two_player_game
    },
    # {
    #   input: '2',
    #   desc: 'Save',
    #   method: :play_two_player_game
    # },
    # {
    #   input: '3',
    #   desc: 'Load',
    #   method: :play_two_player_game
    # },
    {
      input: '0',
      desc: 'Credits',
      method: :display_credits
    }
  ].freeze

  def menu
    display_intro
    loop do
      display_menu
      input = gets.chomp
      MENUS.each { |option| send(option[:method]) if option[:input] == input }
    end
  end

  # Display

  def display_intro
    puts <<~HEREDOC_INTRO

      Runs a CLI game of chess

    HEREDOC_INTRO
  end

  def display_menu
    MENUS.each { |option| puts "#{option[:input]}. #{option[:desc]}" }
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
