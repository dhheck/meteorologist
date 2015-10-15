require 'open-uri'

class MeteorologistController < ApplicationController
  def street_to_weather_form
    # Nothing to do here.
    render("street_to_weather_form.html.erb")
  end

  def street_to_weather
    @street_address = params[:user_street_address]
    url_safe_street_address = URI.encode(@street_address)

    # ==========================================================================
    # Your code goes below.
    # The street address the user input is in the string @street_address.
    # A URL-safe version of the street address, with spaces and other illegal
    #   characters removed, is in the string url_safe_street_address.
    # ==========================================================================

    urlgoog = "https://maps.googleapis.com/maps/api/geocode/json?address=#{url_safe_street_address}"
    goograw_data = open(urlgoog).read

    googparsed_data = JSON.parse(goograw_data)

    @lat = googparsed_data["results"][0]["geometry"]["location"]["lat"]

    @lng = googparsed_data["results"][0]["geometry"]["location"]["lng"]

    fcsturl = "https://api.forecast.io/forecast/377770589379e3b42178c34fb671049e/#{@lat},#{@lng}"

    fcstraw_data = open(fcsturl).read

    fcstparsed_data = JSON.parse(fcstraw_data)

    @current_temperature = fcstparsed_data["currently"]["temperature"]

    @current_summary = fcstparsed_data["currently"]["summary"]

    @summary_of_next_sixty_minutes = fcstparsed_data["minutely"]["summary"]

    @summary_of_next_several_hours = fcstparsed_data["hourly"]["summary"]

    @summary_of_next_several_days = fcstparsed_data["daily"]["summary"]

    render("street_to_weather.html.erb")
  end
end
