require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters.push(("A".."Z").to_a.sample) }
  end

  def score
    @letters = params[:letters].split()
    @word = params[:word]
    @message = "Congratulation! #{@word.capitalize} is a valid english word."
    unless grid_include?(@letters, @word)
      @message = "Sorry but #{@word} cannot be built out of #{params[:letters]}."
      return
    end

    unless word_exists?(@word)
      @message = "Sorry but #{@word} is not an english word."
    end
  end

  private

  def grid_include?(letters, word)
    word.each_char do |letter|
      if letters.include?(letter.upcase)
        letters.delete_at(letters.index(letter.upcase))
      else
        return false
      end
    end
    return true
  end

  def word_exists?(word)
    # Reach dictionnary to check word
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    user_serialized = open(url).read
    # Store word details in a variable
    attempt_details = JSON.parse(user_serialized)
    # Check if word exists => YES : get length // NO : return score 0
    return attempt_details['found']
      # length = attempt_details['length']
  end
end
