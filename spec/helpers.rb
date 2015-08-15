require "json"

module Helpers
  def stub_api_with(body:, status: 200)
    string_body =
      if body.is_a? Hash
        JSON.generate(body).to_s
      end

      stub_request(:any, /^http:\/\/engine.apitie.io\//)
        .to_return(body: string_body, status: status, headers: { "Content-type" => "application/json"})
  end

  def expect_to_hit_api_with(request)
    assert_requested \
      request.keys.first,
      URI.join("http://engine.apitie.io", request.values.first)
  end
end
