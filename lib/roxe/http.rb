module Roxe
  class Http
    DEFAULT_HEADERS = { 'charset' => 'utf-8' }

    attr_reader :oauth, :api_url
    attr_accessor :endpoint

    # oauth: Roxe::OAuth
    # api_url: Xero Remote API URL
    def initialize(oauth:, api_url:)
      @oauth   = oauth
      @api_url = api_url
    end

    def get(resource, options = {})
      response = oauth.access_token.get(request_uri(resource, options),
                                        request_headers)
      Roxe::Response.new(response: response, resource: resource).build
    end

    private

    def request_uri(resource, options = {})
      method = caller[0] =~ /`([^']*)/ && $1.to_sym
      url = "#{api_url}/#{resource.to_s.capitalize}"

      if method == :get && options[:identifier]
        url.concat("/#{options[:identifier]}")
      end

      URI.parse(url).request_uri
    end

    def request_headers
      DEFAULT_HEADERS.merge('User-Agent' => user_agent)
    end

    def user_agent
      'RoxeRubyGem/#{Roxe::VERSION}'
    end
  end
end
