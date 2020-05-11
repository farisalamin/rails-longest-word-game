require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = generate_grid(10)
  end

  def score
  # Wagon Dictionary API call
    @grid = params[:letters].split
    @attempt = params[:word]

    url = "https://wagon-dictionary.herokuapp.com/#{@attempt}"
    dict_json_result = open(url).read
    lookup = JSON.parse(dict_json_result)

    @in_grid = found_in_grid?(@attempt, @grid)
    @is_word = lookup["found"]

    # Getting correct message
    # @message = get_message(@attempt, lookup, in_grid, @grid)
  end

  private

  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    grid_size.times.map { ("A".."Z").to_a.sample }
  end

  def found_in_grid?(attempt, grid)
    attempt_chars = attempt.upcase.chars
    grid.each do |letter|
      if (i = attempt_chars.index(letter.upcase))
        attempt_chars.delete_at(i)
      end
    end
    attempt_chars.empty?
  end

  # def get_message(attempt, lookup, in_grid, grid)
  #   if lookup["found"] && in_grid
  #     "Congratulations! <em>#{attempt.upcase}</em> is a valid English word!"
  #   elsif lookup["found"] == false
  #     "Sorry but <em>#{attempt.upcase}</em> does not seem to be a valid English word..."
  #   else
  #     "Sorry but <em>#{attempt.upcase}</em> cannot be built out of #{grid.join(", ")}"
  #   end
  # end
end
