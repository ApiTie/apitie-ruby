require "apitie/record"
require "apitie/body"
require "apitie/authenticable_request"
require "apitie/api_error"

module ApiTie
  class Engine
    def initialize(config)
      @request = AuthenticableRequest.new(config)
    end

    def get_list(path)
      response = @request.get(path)
      if response.success?
        parse_list response
      else
        fail ApiError.new(response)
      end
    end

    private

    def parse_list(response)
      parsed_records = Hash.new

      response.each_pair do |name, records|
        klass = find_or_bootstrap_klass(name)
        parsed_records[name] = records
          .map(&klass.method(:new))
      end

      Body.new(parsed_records)
    end

    def find_or_bootstrap_klass(name)
      Record.const_get(name.capitalize)
    rescue NameError => e
      Record.const_set(name.capitalize, Class.new(Record))
    end
  end
end
