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

    def access_token
      ::OAuth::AccessToken.new(consumer, token, secret)
    end

    def renew_access_token(oauth_session_handle)
      request_token = ::OAuth::RequestToken.new(consumer, token, secret)
      new_token = request_token.get_access_token({ oauth_session_handle: oauth_session_handle,
                                                   token: request_token },
                                                 {}, nil)
      [new_token.token, new_token.secret]
    end

    private

    def consumer
      ::OAuth::Consumer.new(consumer_key, consumer_secret, connexion.options).tap do |c|
        c.http.cert = connexion.ssl_client_cert
        c.http.key  = connexion.ssl_client_key
      end
    end
  end
end
