require "json"

module Helpers
  def stub_api(path)
    StubbedRequest.new(path)
  end

  def expect_to_hit_api_with(request)
    assert_requested \
      request.keys.first,
      URI.join("http://engine.apitie.io", request.values.first)
  end
end

class StubbedRequest
  attr_reader :stub

  def initialize(path)
    uri = URI.join("http://engine.apitie.io", path.to_s)
    @stub = WebMock::StubRegistry.instance
      .register_request_stub(WebMock::RequestStub.new(:get, uri))
      .to_return(&method(:response))
  end

  def response(*args)
    {
      body: @body || {},
      status: 200,
      headers: { "Content-type" => "application/json"}
    }
  end

  def body(value)
    @body = JSON.generate(value).to_s
    self
  end
end
