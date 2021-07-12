class CatsUnlimitedApi
  class << self
    BASE_URL = 'https://nh7b1g9g23.execute-api.us-west-2.amazonaws.com/dev/cats/json'

    def response
      ApiHelper.response_as_json(BASE_URL)
    end
  end
end
