require "apitie/version"
require "apitie/config"
require "apitie/collection"

module ApiTie
  extend Collection
  extend self

  def config
    if block_given?
      @config = Config.new.tap { |config|
        yield config
      }.validate!
    end
    @config
  end
end
