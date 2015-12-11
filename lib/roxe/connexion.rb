module Roxe
  class Connexion
    DEFAULT_OPTIONS = { request_token_path: '/oauth/RequestToken',
                        access_token_path: '/oauth/AccessToken',
                        authorize_path: '/oauth/Authorize',
                        site: 'https://api-partner.network.xero.com',
                        api_url: 'https://api-partner.network.xero.com/api.xro/2.0',
                        authorize_url: 'https://api.xero.com/oauth/Authorize',
                        ca_file: File.expand_path('config/ca-certificates.crt'),
                        signature_method: 'RSA-SHA1',
                        rate_limit_sleep: 2 }.freeze

    attr_reader :request_token_path, :access_token_path, :authorize_path,
                :site, :api_url, :authorize_url,
                :signature_method, :rate_limit_sleep, :private_key_file_path,
                :ssl_client_cert_path, :ssl_client_key_path,
                :consumer_key, :consumer_secret

    # options: Hash[consumer_key, consumer_secret,
    #               ssl_client_cert_path, ssl_client_key_path,
    #               private_key_file_path]
    def initialize(options: {})
      options.each do |k, v|
        instance_variable_set("@#{k}", v)
      end
    end

    def options
      DEFAULT_OPTIONS.merge(private_key_file: private_key_file_path)
    end

    def ssl_client_cert
      OpenSSL::X509::Certificate.new(File.read(ssl_client_cert_path))
    end

    def ssl_client_key
      OpenSSL::PKey::RSA.new(File.read(ssl_client_key_path))
    end
  end
end
