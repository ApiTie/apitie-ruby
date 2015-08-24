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
        Body.new response
      else
        fail ApiError.new(response)
      end
    end
  end
end
