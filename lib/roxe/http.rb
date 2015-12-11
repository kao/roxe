module Roxe
  class Http
    DEFAULT_HEADERS = { 'User-Agent' => 'Sush.io' , 'charset' => 'utf-8' }

    attr_reader :oauth, :api_url

    # oauth: Roxe::OAuth
    # api_url: Xero Remote API URL
    def initialize(oauth:, api_url:)
      @oauth   = oauth
      @api_url = api_url
    end

    def get(resource)
      oauth.access_token.get(uri(resource).request_uri, request_headers)
    end

    private

    def uri(resource)
      URI.parse("#{api_url}/#{resource.to_s.capitalize}")
    end

    def request_headers
      DEFAULT_HEADERS
    end
  end
end
