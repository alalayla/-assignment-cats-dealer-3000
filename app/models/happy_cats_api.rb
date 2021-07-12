require 'nokogiri'

class HappyCatsApi
  class << self
    BASE_URL = 'https://nh7b1g9g23.execute-api.us-west-2.amazonaws.com/dev/cats/xml'

    def response
      json_response = ApiHelper.response_as_json(BASE_URL)
      unify_response(json_response)
    end

    private

    # Unify the response
    def unify_response(json_response)
      return [] if json_response.empty?

      get_shops_array = json_response['cats']['cat']
      cost_to_price(get_shops_array)
      title_to_name(get_shops_array)
      img_to_image(get_shops_array)
    end

    def cost_to_price(response)
      response.each { |shop| shop['price'] = shop.delete 'cost' }
    end

    def title_to_name(response)
      response.each { |shop| shop['name'] = shop.delete 'title' }
    end

    def img_to_image(response)
      response.each { |shop| shop['image'] = shop.delete 'img' }
    end
  end
end
