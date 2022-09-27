require "json"
require "open-uri"

class GamesController < ApplicationController
  $nb_of_games = 0
  $overall_score = 0
  VOWELS = %w[A E I O U Y]

  def new
    @letters = (VOWELS.sample(5) + (("A".."Z").to_a - VOWELS).sample(5)).shuffle
    @word = params[:guess]
    unless @word.nil?
      $nb_of_games += 1
      grid = params[:grid].split
      word_letters = @word.upcase.chars
      @message = ""
      @found = false
      if check_if_in_grid(grid, word_letters)
        if check_if_exists(@word)
          score = compute_score(@word)
          $overall_score += score
          @message = "Congratulations! \"#{@word.capitalize}\" is a valid English word. You won #{score} point#{score == 1 ? "" : "s"}."
        else
          @message = "Sorry, \"#{@word}\" does not seem to be a valid English word. No points awarded for this round."
        end
      else
        @message = "Sorry, it seems like \"#{@word}\" can't be build out of #{grid.join(",")}. No points awarded for this round."
      end
      @message
    end
  end

  private

  def check_if_in_grid(grid, word_letters)
    check = grid.map { |letter| grid.count(letter) >= word_letters.count(letter) }
    check.all?
  end

  def check_if_exists(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    entry_serialized = URI.open(url).read
    entry = JSON.parse(entry_serialized)
    entry["found"]
  end

  def compute_score(word)
    word.length
  end
end
