module ApiTie
  Error = Class.new(StandardError)
  MissingCredential = Class.new(Error)

  class Config
    attr_accessor :public_key, :private_key

    def validate!
      if public_key.nil?
        fail MissingCredential, "public key is missing"
      end
      if private_key.nil?
        fail MissingCredential, "private key is missing"
      end
      self
    end
  end
end
