require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    new_letters
  end

  def score
    # params[:letters] is a string 'A K W E R Y F S G C'
    # .split converts to array
    @display_letters = params[:letters].split(' ')
    @answer = params[:answer]
    @word = method_json
    score_and_message(5)
  end

  private

  def new_letters
    alphabet_array = ('A'..'Z').to_a
    10.times { @letters << alphabet_array.sample }
  end

  def method_json
    url = "https://wagon-dictionary.herokuapp.com/#{@answer}"
    word_checker = URI.open(url).read
    JSON.parse(word_checker)
  end

  def score_and_message(time_diff)
    if @word['found'] == true
      @result = { message: "Congratulations #{@answer.upcase} is a valid English Word!",
                  score: (@answer.length).fdiv(time_diff) }
      if compare == false
        @result = { message: "Sorry but #{@answer.upcase} can't be built out of #{@display_letters}", score: 0 }
      end
    else
      @result = { message: "Sorry but #{@answer.upcase} does not seem to be a valid english word", score: 0 }
    end
  end

  def compare
    # compare array attemp and grid
    # answer must be in grid
    # loop on answer to find each character
    # find each element in grid
    # if found, delete
    # else other alphabets were used
    grid = @display_letters
    alphabet_num = true
    @answer.chars.each do |character|
      position = grid.index(character)
      position ? grid.delete_at(position) : alphabet_num = false
    end
    alphabet_num
  end
end
