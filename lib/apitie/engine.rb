require "apitie/record"
require "apitie/body"
require "apitie/authenticable_request"

module ApiTie
  class Engine
    def initialize(config)
      @request = AuthenticableRequest.new(config)
    end

    def get_list(path)
      parse_list @request.get(path)
    end

    private

    def parse_list(response)
      parsed_records = Hash.new

      response.each_pair do |name, records|
        klass = Class.new(Record)
        parsed_records[name] = records
          .map(&klass.method(:new))
      end

      Body.new(parsed_records)
    end
  end
end
