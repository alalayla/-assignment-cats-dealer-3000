require 'rails_helper'

RSpec.describe ShopsController do
  describe "GET shop#index", :type => :request do
    before(:each) do
      stub_request(:get, 'https://nh7b1g9g23.execute-api.us-west-2.amazonaws.com/dev/cats/json').to_return(:body => File.read('spec/fixtures/cats_unlimited_api.json').strip)
      stub_request(:get, 'https://nh7b1g9g23.execute-api.us-west-2.amazonaws.com/dev/cats/xml').to_return(:body => File.read('spec/fixtures/happy_cats_api.xml').strip)
    end

    context "using city parameter" do
      it "should return the cheapest shop" do
        get '/shop?city=Lviv'

        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        expect(json_response).to eq({
            'location' => 'Lviv',
            'price' => 50,
            'name' => 'Abyssin',
            'image' => 'https://test.image.jpg'
        })
      end
    end

    context "using cat_breed parameter" do
      it "should return the cheapest shop" do
        get "/shop?cat_breed=Bengal"

        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        expect(json_response).to eq({
                                        'location' => 'Kyiv',
                                        'price' => 30,
                                        'name' => 'Bengal',
                                        'image' => 'https://test.image.jpg'
                                    })
      end
    end

    context "using both city and cat_breed parameters" do
      it "should return the cheapest shop" do
        get "/shop?cat_breed=Bengal&city=Odessa"

        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        expect(json_response).to eq({
                                        'location' => 'Odessa',
                                        'price' => 80,
                                        'name' => 'Bengal',
                                        'image' => 'https://test.image.jpg'
                                    })
      end
    end

    context "with no parameters" do
      it "should return the cheapest shop" do
        get "/shop"

        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        expect(json_response).to eq({
                                        'name' => 'American Curl',
                                        'price' => 20,
                                        'location' => 'Kherson',
                                        'image' => 'https://test.image.jpg'
                                    })
      end
    end

    context "using non-existing city" do
      context "with no parameters" do
        it "should return an empty response" do
          get "/shop?city=Mulholland+Drive"

          expect(response).to have_http_status(:ok)

          json_response = JSON.parse(response.body)
          expect(json_response).to eq([])
        end
      end
    end

    context "when the external API is down" do
      before(:each) do
        stub_request(:get, 'https://nh7b1g9g23.execute-api.us-west-2.amazonaws.com/dev/cats/json').to_return(:body => nil)
        stub_request(:get, 'https://nh7b1g9g23.execute-api.us-west-2.amazonaws.com/dev/cats/xml').to_return(:body => nil)
      end

      it "should return an empty response" do
        get "/shop?city=Kyiv"

        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        expect(json_response).to eq([])
      end
    end
  end
end
