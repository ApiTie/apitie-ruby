require "apitie/version"
require "apitie/config"

module ApiTie
  extend self

  ADDRESS = "engine.apitie.io"

  def config
    if block_given?
      @config = Config.new.tap { |config|
        yield config
      }.validate!
    end
    @config
  end
end
