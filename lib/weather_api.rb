class WeatherApi
  def self.weather_in(city)
    city = city.downcase
    url = "http://api.weatherstack.com/current?access_key=#{key}&query=#{ERB::Util.url_encode(city)}"
    response = HTTParty.get url
    weather = response.parsed_response["current"]
    return nil if weather.nil?

    weather["location"] = response.parsed_response["location"]["name"]
    Weather.new(weather)
  end

  def self.key
    return nil if Rails.env.test? # testatessa ei apia tarvita, palautetaan nil
    raise 'WEATHER_APIKEY env variable not defined' if ENV['WEATHER_APIKEY'].nil?

    ENV.fetch('WEATHER_APIKEY')
  end
end
