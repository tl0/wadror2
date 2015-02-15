class BeermappingApi
  def self.places_in(city)
    city = city.downcase
    Rails.cache.fetch(city, expires_in:7200) { fetch_places_in(city) }
  end

  def self.search_id(id)
    Rails.cache.fetch("id_#{id}", expires_in:1) { fetch_with_id(id) }
  end

  private

  def self.fetch_places_in(city)
    url = "http://beermapping.com/webservice/loccity/#{key}/"

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    places = response.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) and places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.inject([]) do | set, place |
      set << Place.new(place)
    end
  end

  def self.fetch_with_id(id)
    url = "http://beermapping.com/webservice/locquery/#{key}/"

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(id)}"
    place = response.parsed_response["bmp_locations"]["location"]

    #return [] if places.is_a?(Hash) and places['id'].nil?

    #place["name
    # "]

    return place
  end


  def self.key
    "37b99f2346983d2ce71d27bfbc91e642"
  end
end
