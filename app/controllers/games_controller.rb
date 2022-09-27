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
      @grid = params[:grid].split
      word_letters = @word.upcase.chars
      @in_grid = check_if_in_grid(@grid, word_letters)
      @valid_english_word = check_if_exists(@word)
      if @in_grid && @valid_english_word
        @score = compute_score(@word)
        $overall_score += @score
      end
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
