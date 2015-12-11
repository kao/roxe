require 'oauth'

module Roxe
  class OAuth
    attr_reader :connexion, :consumer_key, :consumer_secret, :token, :secret

    # connexion: Roxe::Connexion
    # credentials: Hash[consumer_key, consumer_secret, token, secret]
    def initialize(connexion:, credentials:)
      @connexion       = connexion
      @consumer_key    = credentials[:consumer_key]
      @consumer_secret = credentials[:consumer_secret]
      @token           = credentials[:token]
      @secret          = credentials[:secret]
    end

    # delegate to access_token

    def consumer
      ::OAuth::Consumer.new(consumer_key, consumer_secret, connexion.options).tap do |c|
        c.http.cert = connexion.ssl_client_cert
        c.http.key  = connexion.ssl_client_key
      end
    end

    def access_token
      ::OAuth::AccessToken.new(consumer, token, secret)
    end
  end
end
