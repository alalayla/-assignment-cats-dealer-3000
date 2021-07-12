require 'nokogiri'

module ApiHelper
  class << self

    def get_data(url)
      RestClient.get(url)
    end

    def response_as_json(url)
      response = get_data(url)
      if response.code.to_i == 200 && !response.body.empty?
        is_xml?(response) ? xml_to_json(response) : JSON.parse(response)
      else
        []
      end
    end

    private
    def xml_to_json(response)
      xml_obj = Nokogiri::XML(response)
      Hash.from_xml(xml_obj.to_xml)
    end

    def is_xml?(response)
      response.body.starts_with? '<?xml'
    end
  end
end
