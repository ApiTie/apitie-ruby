module ApiTie
  Error = Class.new(StandardError)

  class ApiError
    def initialize(response)
      @response = response
    end

    def exception
      Error.new(@response["errors"].join)
    end
  end
end
