require "apitie/engine"

module ApiTie
  module Collection
    def fetch_all(collection_name)
      engine.get_list("/#{collection_name}")
    end

    private

    def engine
      @engine ||= Engine.new(config)
    end
  end
end
