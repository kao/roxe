module Roxe
  class Http
    DEFAULT_HEADERS = { 'User-Agent' => 'Sush.io', 'charset' => 'utf-8' }

    attr_reader :oauth, :api_url

    # oauth: Roxe::OAuth
    # api_url: Xero Remote API URL
    def initialize(oauth:, api_url:)
      @oauth   = oauth
      @api_url = api_url
    end

    def get(resource)
      response = oauth.access_token.get(request_uri(resource),
                                        request_headers)
      Response.new(response: response, resource: resource).build
    end

    private

    def request_uri(resource)
      URI.parse("#{api_url}/#{resource.to_s.capitalize}").request_uri
    end

    def request_headers
      DEFAULT_HEADERS
    end
  end
end
