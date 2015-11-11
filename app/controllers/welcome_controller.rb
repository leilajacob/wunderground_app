class WelcomeController < ApplicationController
  def test
	response = HTTParty.get("http://api.wunderground.com/api/#{ENV['wunderground_api_key']}/geolookup/conditions/q/FR/Paris.json")
  
  @location = response['location']['city']
  @temp_f = response['current_observation']['temp_f']
  @temp_c = response['current_observation']['temp_c']
  @weather_icon = response['current_observation']['icon_url']
  @weather_words = response['current_observation']['weather'] 
  @forecast_link = response['current_observation']['forecast_url']
  @real_feel = response['current_observation']['feelslike_f']
  end

  def index


    
          

  	@states = %w(HI AK CA OR WA ID UT NV AZ NM CO WY MT ND SD NB KS OK TX LA AR MO IA MN WI IL IN MI OH KY TN MS AL GA FL SC NC VA WV DE MD PA NY NJ CT RI MA VT NH ME DC PR)
   @states.sort!

   @location_list = Location.all
   
  	if params[:city] != nil

  		location_exists = false
  		Location.all.each do |l|
  			if l.city == params[:city] && l.state == params[:state]
  				location_exists = true
  			end 
  		end 

  		if location_exists == false
	  		location = Location.new
	  		location.city = params[:city]
	  		location.state = params[:state]
	  		location.save
  		end

  		params[:city] = params[:city].gsub(" ", "_")

	  	response = HTTParty.get("http://api.wunderground.com/api/#{ENV['wunderground_api_key']}/geolookup/conditions/q/#{params[:state]}/#{params[:city]}.json")
	  
		  @location = response['location']['city']
		  @temp_f = response['current_observation']['temp_f']
		  @temp_c = response['current_observation']['temp_c']
		  @weather_icon = response['current_observation']['icon_url']
		  @weather_words = response['current_observation']['weather'] 
		  @forecast_link = response['current_observation']['forecast_url']
		  @real_feel = response['current_observation']['feelslike_f']

      if @weather_words.include?("Rain")
        @body_id="rain"
      elsif @weather_words.include?("Cloudy")
        @body_id="cloudy"
      elsif @weather_words.include?("Overcast")
        @body_id="cloudy"
      elsif @weather_words.include?("MostlyCloudy")
        @body_id="cloudy"
      elsif @weather_words.include?("Flurries")
        @body_id="snow"
      elsif @weather_words.include?("Sleet")
        @body_id="snow"
      elsif @weather_words.include?("Tstorms")
        @body_id="storm"
      else
        @body_id="sunny"
      end
		end
  
  end
end
