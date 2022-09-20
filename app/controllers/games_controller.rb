require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = ("A".."Z").to_a.sample(10)
  end

  def score
    @word = params[:guess]
    grid = params[:grid].split
    word_letters = @word.upcase.chars
    @message = ""
    @found = false
    # raise
    if check_if_in_grid(grid, word_letters)
      if check_if_exists(@word)
        @message = "Congratulations! #{@word.upcase} is a valid English word. You won #{compute_score(@word)} point#{compute_score(@word) == 1 ? "" : "s"}."
      else
        @message = "Sorry but #{@word.upcase} does not seem to be a valid English word"
      end
    else
      @message = "Sorry but #{@word.upcase} can't be build out of #{grid.join(",")}"
    end
    @message
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