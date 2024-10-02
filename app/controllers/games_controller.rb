require 'net/http'
require 'uri'
require 'json'

class GamesController < ApplicationController
  def new
    # Define the range of letters you want to use (A-Z)
    alphabet = ('A'..'Z').to_a
    # Create a new array with 10 elements using Array.new
    @letters = Array.new(10) { alphabet.sample }
  end

def word_in_grid?(word, letters)
    word = word.upcase
    letters = letters.map(&:upcase)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def valid_english_word?(word)
    uri = URI("https://api.dictionaryapi.dev/api/v2/entries/en/#{URI.encode_www_form_component(word)}")

    begin
      response = Net::HTTP.get_response(uri)

      if response.is_a?(Net::HTTPSuccess)
        json_response = JSON.parse(response.body)
        # Determine if it's a valid word based on the JSON structure
        # You'll likely need to check the contents of json_response to determine validity.
        json_response.any? # Adjust this condition based on the API response structure
      else
        false
      end
    rescue JSON::ParserError, Net::OpenTimeout, Net::ReadTimeout, URI::InvalidURIError
      false
    end
  end

def score
  @word = params[:word].upcase
  @original_letters = params[:letters].upcase.split(',')

    if word_in_grid?(@word, @original_letters)
      if valid_english_word?(@word)
        @message = "Congratulations! #{@word} is a valid English word!"
      else
        @message = "Sorry, but #{@word} does not seem to be a valid English word."
      end
    else
      @message = "Sorry, but #{@word} can't be built out of #{@original_letters}."
    end
  end
end
