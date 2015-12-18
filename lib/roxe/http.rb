module Roxe
  class Http
    DEFAULT_HEADERS = { 'charset' => 'utf-8' }

    attr_reader :oauth, :api_url, :options

    # oauth: Roxe::OAuth
    # api_url: Xero Remote API URL
    def initialize(oauth:, api_url:, options:)
      @oauth   = oauth
      @api_url = api_url
      @options = options
    end

    def self.method_missing(method, *args, &block)
      return super unless Roxe::HTTP_VERBS.include?(method)

      new(*args).send(method)
    end

    def get
      response = oauth.access_token.get(request_uri(*options),
                                        request_headers)
      Roxe::Response.new(response: response, resource: options[0]).build
    end

    private

    def request_uri(resource)
      URI.parse("#{api_url}/#{resource.to_s.capitalize}").request_uri
    end

    def request_headers
      DEFAULT_HEADERS.merge('User-Agent' => user_agent)
    end

    def user_agent
      'RoxeRubyGem/#{Roxe::VERSION}'
    end
  end
end
