require "apitie/to_query"
require "httparty"

module ApiTie
  class AuthenticableRequest
    using ToQuery

    include HTTParty
    base_uri "engine.apitie.io"

    def initialize(config)
      @config = config
    end

    def get(path)
      self.class.get \
        path, headers: auth_headers_for(:get)
    end

    private

    def auth_headers_for(verb)
      timestamp = Time.now.utc.to_i
      {
        'X-Access-Token' => @config.public_key,
        'X-Request-Timestamp' => timestamp.to_s,
        'X-Request-Hash' => calculate_hmac(verb, {}, timestamp)
      }
    end

    def calculate_hmac(verb, params, timestamp)
      digest = OpenSSL::Digest.new("sha1")
      data = "#{verb}#{timestamp}#{params.to_query}"
      OpenSSL::HMAC.hexdigest(digest, @config.private_key, data)
    end
  end
end
