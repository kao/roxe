require 'active_support'
require 'active_support/core_ext'

module Roxe
  class Http
    DEFAULT_HEADERS = { 'charset' => 'utf-8',
                        'Content-Type' => 'application/x-www-form-urlencoded' }

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
      build(response, resource)
    end

    def post(resource, options = {})
      xml = options.to_xml(root: resource.to_s.singularize.classify)
      response = oauth.access_token.post(request_uri(resource),
                                         { xml: xml },
                                         request_headers)
      build(response, resource)
    end

    private

    def build(response, resource)
      resource = resource.to_s.capitalize
      Hash.from_xml(response.body)['Response'][resource][resource.singularize]
    end

    def request_uri(resource, options = {})
      method = caller[0] =~ /`([^']*)/ && $1.to_sym
      url = "#{api_url}/#{resource.to_s.capitalize}"

      return URI.parse(url).request_uri if method != :get

      if options[:identifier]
        url.concat("/#{options[:identifier]}")
      elsif options[:where]
        url.concat("?where=#{options[:where]}")
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
