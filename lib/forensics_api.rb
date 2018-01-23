require 'httparty'

class ForensicsAPI
  BASE_URL = 'http://which-technical-exercise.herokuapp.com/api/'
  SERVER_ERROR_MESSAGE = 'The server could not be reached at this moment please try again soon'
  ServerError = StandardError.new(SERVER_ERROR_MESSAGE)

  def initialize(email_address)
    @email_address = email_address
  end

  def retrieve_directions
    response = HTTParty.get("#{BASE_URL}#{email_address}/directions")

    if response.code == 200
      JSON.parse(response.body).fetch('directions')
    else
      raise ServerError
    end
  end

  def check_location(x: x_axis, y: y_axis)
    response = HTTParty.get("#{BASE_URL}#{email_address}/location/#{x}/#{y}")

    if response.code == 200
      JSON.parse(response.body)['message'] + " For location X: #{x}, Y: #{y}"
    else
      raise ServerError
    end
  end

  private

  attr_reader :email_address, :coordinates
end
