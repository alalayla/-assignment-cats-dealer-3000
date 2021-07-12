class ShopsController < ApplicationController

  # GET shops
  #   params:
  #     city [String] - City
  #     cat_breed [String] - Cat breed
  def index
    @cats_unlimited_api = CatsUnlimitedApi.response
    @happy_cats_api = HappyCatsApi.response

    all_results_json = merge_api_responses([@cats_unlimited_api, @happy_cats_api])
    optimal_shop = find_optimal_shop(all_results_json, {city: params[:city], cat_breed: params[:cat_breed]})

    render json: optimal_shop, status: :ok
  rescue StandardError => e
    render json: {errors: e.message}, status: :unprocessable_entity
  end

  private

  # Merge the response of all APIs into one JSON
  def merge_api_responses(api_responses)
    merged_response = []
    api_responses.each { |response| merged_response << response }
    merged_response.flatten.map(&:symbolize_keys)
  end

  # Find the cheapest shop, using the parameters city and cat_breed
  def find_optimal_shop(shops_json, **opts)
    return [] if shops_json.empty?

    shops_json.select!{|i| i[:location].downcase == opts[:city].downcase} if opts[:city]
    shops_json.select!{|i| i[:name].downcase == opts[:cat_breed].downcase} if opts[:cat_breed]

    return [] if shops_json.empty?

    cheapest_shop = count_the_cheapest_shop(shops_json)
    convert_price_to_integer(cheapest_shop)
  end

  # Choose the shop with the cheapest price
  def count_the_cheapest_shop(shops)
    shops.min { |a,b| a[:price].to_i <=> b[:price].to_i }
  end

  def convert_price_to_integer(shop)
    shop[:price] = shop[:price].to_i
    shop
  end
end
